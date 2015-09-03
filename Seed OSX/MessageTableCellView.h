#import <Cocoa/Cocoa.h>

@interface MessageTableCellView : NSTableCellView

@property (weak) IBOutlet NSTextField *textLabel;
@property (weak) IBOutlet NSTextField *emailLabel;

@end
