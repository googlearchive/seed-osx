#import <Cocoa/Cocoa.h>
#import <Firebase/Firebase.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *inputField;

@property (strong) Firebase *ref;
@property (strong) FAuthData *user;
@property (strong) NSMutableArray *snapshots;

@end

