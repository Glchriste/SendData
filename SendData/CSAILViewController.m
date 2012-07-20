#import "CSAILViewController.h"
#import "AVCamViewController.h"

@implementation CSAILViewController

@synthesize dataSession;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	dataPicker = [[GKPeerPickerController alloc] init];
	dataPicker.delegate = self;
	
	//There are 2 modes of connection type 
	// - GKPeerPickerConnectionTypeNearby via BlueTooth
	// - GKPeerPickerConnectionTypeOnline via Internet
	// We will use Bluetooth Connectivity for this example
	
	dataPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	dataPeers=[[NSMutableArray alloc] init];
	
	// Create the buttons
    UIButton *btnConnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnConnect addTarget:self action:@selector(connectToPeers:) forControlEvents:UIControlEventTouchUpInside];
	[btnConnect setTitle:@"Seek iOS Cameras as Server" forState:UIControlStateNormal];
	btnConnect.frame = CGRectMake(20, 100, 280, 30);
	btnConnect.tag = 11;
	[self.view addSubview:btnConnect];
    
    
	UIButton *btnConnect2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnConnect2 addTarget:self action:@selector(connectToPeers:) forControlEvents:UIControlEventTouchUpInside];
	[btnConnect2 setTitle:@"Seek iOS Cameras as Client" forState:UIControlStateNormal];
	btnConnect2.frame = CGRectMake(20, 140, 280, 30);
	btnConnect2.tag = 12;
	[self.view addSubview:btnConnect2];
	
}

// Connect to other peers by displayign the GKPeerPicker 
- (void) connectToPeers:(id) sender{
    if([sender tag]==11)
    {
        isHost = YES;
    }
    else {
        isHost = NO;
    }
    
	//[dataPicker show];
    
    //Globals *globals = [Globals shareData];
    
    // Set this up as a server
    if (isHost) {
        GKSession *session = [[GKSession alloc] initWithSessionID:@"com.grace.senddata" displayName:@"Server" sessionMode:GKSessionModeServer];
        self.dataSession = session;
        //self.dataSession.available = YES;
        session.delegate = self;
        session.available = YES;       
        NSLog(@"Setting Server Session Peer:%@",  session.peerID);
        //[self.dataSession setDataReceiveHandler:self withContext:nil];
        //globals.localSession = session;
    } 
    
    // or set it up as a client
    else {
        GKSession *session = [[GKSession alloc] initWithSessionID:@"com.grace.senddata" displayName:nil sessionMode:GKSessionModeClient];
        self.dataSession = session;
        self.dataSession.available = YES;
        session.delegate = self;
        session.available = YES;
        NSLog(@"Setting CLIENT Session Peer:%@", session.peerID);
        //globals.localSession = session;
        [self.dataSession setDataReceiveHandler:self withContext:nil];
    }
    
     self.dataSession.available = YES;
    //[self.dataSession setDataReceiveHandler:self withContext:nil];
}



- (void) requestCapture:(id)sender{
    NSString *msg = @"capture";
    [dataSession sendData:[msg dataUsingEncoding: NSASCIIStringEncoding] toPeers:dataPeers withDataMode:GKSendDataReliable error:nil];

    //Code to bring up camera view and take a picture.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    AVCamViewController *cam = (AVCamViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AVCam"];
    [self presentModalViewController:cam animated:YES];
    
    
    /*________________________________
     | Takes a photo programmatically. |
     --------------------------------*/
    sleep(1); //For some reason, capturing a still image does not work unless there is a small delay.
    [cam capturePicture]; //Capture still image.
    
}



- (void)dealloc {
	//[dataPeers release];
    //[super dealloc];
}

#pragma mark -
#pragma mark GKPeerPickerControllerDelegate


// This creates a unique Connection Type for this particular applictaion
/*- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	// Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
    GKSession* session = [[GKSession alloc] initWithSessionID:@"com.grace.senddata" displayName:nil sessionMode:GKSessionModePeer];

    return session;
}*/

// Tells us that the peer was connected
/*- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	// Get the session and assign it locally
    self.dataSession = session;
    session.delegate = self;
    
    //No need of teh picekr anymore
	picker.delegate = nil;
    [picker dismiss];
    //[picker autorelease];
}
*/
// Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	//Convert received NSData to NSString to display
   	NSString *whatDidIGet = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	//Dsiplay the data as a UIAlertView
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Received" message:whatDidIGet delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
    
    if([whatDidIGet isEqualToString:@"capture"])
    {
        //Code to bring up camera view and take a picture.
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        AVCamViewController *cam = (AVCamViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AVCam"];
        [self presentModalViewController:cam animated:YES];
        
        /*________________________________
         | Takes a photo programmatically. |
         --------------------------------*/
        sleep(1); //For some reason, capturing a still image does not work unless there is a small delay.
        [cam capturePicture]; //Capture still image.
        
    }
    
    
	//[alert release];
	//[whatDidIget release];
}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
    self.dataSession = session;
    
	switch(state){
        //Other Device Found, attempt to connect.
        case GKPeerStateAvailable:
        {
            NSLog(@"Client available...");
            [session connectToPeer:peerID withTimeout:0];
        }
            break;
        //Connecting
        case GKPeerStateConnecting:
        {
            NSLog(@"Client Connecting...");
        }
            break;
        //Client device connected to server.
        case GKPeerStateConnected:
        {
            NSLog(@"Client connected!");
            // Used to acknowledge that we will be sending data
            [session setDataReceiveHandler:self withContext:nil];
            
            // Add the peer to the Array
            [dataPeers addObject:peerID];
        
            NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            //[alert release];
		
            // Used to acknowledge that we will be sending data
            [session setDataReceiveHandler:self withContext:nil];
		
            [[self.view viewWithTag:11] removeFromSuperview];
            [[self.view viewWithTag:12] removeFromSuperview];
		
            UIButton *btnRequest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btnRequest addTarget:self action:@selector(requestCapture:) forControlEvents:UIControlEventTouchUpInside];
            [btnRequest setTitle:@"Request Camera Shot" forState:UIControlStateNormal];
            btnRequest.frame = CGRectMake(20, 150, 280, 30);
            btnRequest.tag = 13;
            [self.view addSubview:btnRequest];
        }
            break;
        //Client disconnected.
        case GKPeerStateDisconnected:
        {
            NSLog(@"Client Disconnected.");
        }
            break;
        //Client unavailable.
        case GKPeerStateUnavailable:
        {
            NSLog(@"Client is unavailable.");
        }
            break;
    }
		
	
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    NSLog(@"Recieved Connection Request");
    NSLog(@"%@", peerID);
    NSString * peerName = [session displayNameForPeer:peerID];
    NSLog(@"%@", peerName);
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Request" message:[NSString stringWithFormat:@"The Client %@ is trying to connect.", peerName] delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
    [alert show];
    //[alert release];
    if(selection == @"accept"){
        [session acceptConnectionFromPeer:peerID error:nil];
    }else{
        [session denyConnectionFromPeer:peerID];
    }*/
    
    [session acceptConnectionFromPeer:peerID error:nil];
    
}

@end
