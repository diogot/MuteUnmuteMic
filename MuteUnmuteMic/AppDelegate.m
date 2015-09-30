#import "AppDelegate.h"
#import "RHStatusItemView.h"

#define MAX_VOLUME 75

@interface AppDelegate ()
{
    __weak IBOutlet NSMenu *mainMenu;
    
    RHStatusItemView *micView;
    BOOL muted;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    muted = NO;
    
    NSStatusItem *menuItem = [[NSStatusBar systemStatusBar] statusItemWithLength:24];
    menuItem.highlightMode = YES;
    
    micView = [[RHStatusItemView alloc] initWithStatusBarItem:menuItem];
    micView.menu = mainMenu;
    
    NSImage *image = [NSImage imageNamed:@"mic_on"];
    image.template = NO;
    
    micView.image = image;
    micView.alternateImage = image;
    micView.target = self;
    micView.action = @selector(toggleMute);
    micView.rightMenu = [self createQuitMenu];
    
    menuItem.view = micView;
}

- (void)toggleMute {
    muted = !muted;
    
    int volume = muted ? 0 : MAX_VOLUME;
    NSString *source = [NSString stringWithFormat:@"set volume input volume %d", volume];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    
    [script executeAndReturnError:nil];
    
    NSString *imageName = muted ? @"mic_off" : @"mic_on";
    micView.image = [NSImage imageNamed:imageName];
    micView.alternateImage = [NSImage imageNamed:imageName];
}

- (NSMenu *)createQuitMenu {
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Sair"
                                                      action:@selector(killApp)
                                               keyEquivalent:@""];
    quitItem.target = self;
    
    NSMenu *quitMenu = [NSMenu new];
    [quitMenu addItem:quitItem];
    
    return quitMenu;
}

- (void)killApp {
    [NSApp terminate:nil];
}

@end
