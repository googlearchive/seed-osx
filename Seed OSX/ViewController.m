#import "ViewController.h"
#import "MessageTableCellView.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.snapshots = [[NSMutableArray alloc] init];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  // Login/Logout methods
  NSMenuItem *loginItem = [[[[NSApp mainMenu] itemWithTitle:@"File"] submenu] itemWithTag:12345];
  [loginItem setTarget:self];
  [loginItem setAction:@selector(toggleAuth)];
  
  // Initialize Firebase
  [self initFirebase];
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
}

#pragma mark -
#pragma mark Firebase initialization methods

- (void)initFirebase {
  // Initialize Firebase reference
  #error Make sure to change "https://<YOUR-FIREBASE-APP>.firebaseio.com" to your Firebase application
  self.ref = [[Firebase alloc] initWithUrl:@"https://<YOUR-FIREBASE-APP>.firebaseio.com"];
  
  [[self.ref childByAppendingPath:@"messages"] observeEventType:FEventTypeChildAdded
                         andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot,
                                                          NSString *previousChildKey) {
    NSUInteger index = [self indexForKey:previousChildKey] + 1;
    [self.snapshots insertObject:snapshot atIndex:index];
    [self.tableView reloadData];
  }];
  
  // Initialize Auth Listener
  [self.ref observeAuthEventWithBlock:^(FAuthData* authData) {
    self.user = authData;
    NSMenuItem *loginItem = [[[[NSApp mainMenu] itemWithTitle:@"File"] submenu] itemWithTag:12345];
    loginItem.title = self.user ? @"Log Out" : @"Log In";

    self.view.window.title = self.user ? self.user.providerData[@"email"] : @"Please Log In";
  }];
}

- (NSUInteger)indexForKey:(NSString *)key {
  if (!key) return -1;
  
  for (NSUInteger index = 0; index < [self.snapshots count]; index++) {
    if ([key isEqualToString:[(FDataSnapshot *)[self.snapshots
                                                objectAtIndex:index] key]]) {
      return index;
    }
  }
  
  NSString *errorReason =
  [NSString stringWithFormat:@"Key \"%@\" not found in FirebaseArray %@",
   key, self.snapshots];
  @throw [NSException exceptionWithName:@"FirebaseArrayKeyNotFoundException"
                                 reason:errorReason
                               userInfo:@{
                                          @"Key" : key,
                                          @"Array" : self.snapshots
                                          }];
}

#pragma mark -
#pragma mark NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [self.snapshots count];
}

#pragma mark -
#pragma mark NSTableViewDelegate methods

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  MessageTableCellView *result = [tableView makeViewWithIdentifier:@"FirstCell" owner:self];
  NSDictionary *message = [(FDataSnapshot *)[self.snapshots objectAtIndex:row] value];
  result.textLabel.stringValue = message[@"text"];
  result.emailLabel.stringValue = message[@"email"];
  return result;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
  return 44.0;
}

#pragma mark -
#pragma mark Authentication Helpers

- (void)toggleAuth {
  if (self.user) {
    // Unauth if we're already authenticated
    [self.ref unauth];
  } else {
    // Auth if we're not authenticated
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Please enter your email and password"];
    [alert addButtonWithTitle:@"Log in"];
    [alert addButtonWithTitle:@"Cancel"];
    
    // Add email and password inputs
    NSTextField *emailInput = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 32, 240, 24)];
    emailInput.placeholderString = @"email@domain.com";
    
    NSSecureTextField *passwordInput = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 240, 24)];
    passwordInput.placeholderString = @"password";
    
    NSView *inputView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 240, 56)];
    [inputView addSubview:emailInput];
    [inputView addSubview:passwordInput];
    
    [alert setAccessoryView:inputView];
    
    NSInteger button = [alert runModal];
    if (button == NSAlertFirstButtonReturn) {
      [self authOrCreateUser:emailInput.stringValue password:passwordInput.stringValue];
    }
  }
}

- (void)authOrCreateUser:(NSString*)user password:(NSString*)password {
  [self.ref authUser:user
            password:password
 withCompletionBlock:^(NSError* error, FAuthData* authData) {
   switch (error.code) {
     case FAuthenticationErrorUserDoesNotExist:
       [self.ref createUser:user
                   password:password
        withCompletionBlock:^(NSError* error) {
          if (!error) {
            [self authOrCreateUser:user password:password];
          }
        }];
       break;
   }
 }];
}

#pragma mark -
#pragma mark NSControlTextEditingDelegate methods

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
  if (self.user) {
    NSString *text = [fieldEditor.string copy];
    [[[self.ref childByAppendingPath:@"messages"] childByAutoId] setValue:@{@"email": self.user.providerData[@"email"], @"text": text}];
    fieldEditor.string = @"";
  } else {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Please Log In: File > Log In"];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
  }
  return YES;
}


@end
