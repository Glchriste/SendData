#import "CSAILViewController.h"
#import "AVCamViewController.h"

@implementation CSAILViewController

@synthesize dataSession;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    //The array storing connected devices.
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

// Connect to other peers in the area that are detected (uses BlueTooth).
- (void) connectToPeers:(id) sender{
    if([sender tag]==11)
    {
        isHost = YES;
    }
    else {
        isHost = NO;
    }

    //Set this up as a server
    if (isHost) {
        GKSession *session = [[GKSession alloc] initWithSessionID:@"com.grace.senddata" displayName:@"Server" sessionMode:GKSessionModeServer];
        self.dataSession = session;
        session.delegate = self;
        session.available = YES;       
        NSLog(@"Setting Server Session Peer:%@",  session.peerID);

    } 
    
    //Or set it up as a client
    else {
        GKSession *session = [[GKSession alloc] initWithSessionID:@"com.grace.senddata" displayName:nil sessionMode:GKSessionModeClient];
        self.dataSession = session;
        self.dataSession.available = YES;
        session.delegate = self;
        session.available = YES;
        NSLog(@"Setting CLIENT Session Peer:%@", session.peerID);
        [self.dataSession setDataReceiveHandler:self withContext:nil];
    }
    
     self.dataSession.available = YES;
}



- (void) requestCapture:(id)sender{
    NSString *msg = @"capture";
    
    //Send msg to one device.
    //[dataSession sendData:[msg dataUsingEncoding: NSASCIIStringEncoding] toPeers:dataPeers withDataMode:GKSendDataReliable error:nil];
    
    //Tells all the connected clients to take a picture.
    [dataSession sendDataToAllPeers:[msg dataUsingEncoding:NSASCIIStringEncoding] withDataMode:GKSendDataReliable error:nil];

    //Code to bring up camera view and take a picture.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    AVCamViewController *cam = (AVCamViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AVCam"];
    [self presentModalViewController:cam animated:YES];
    
    //Takes a picture on the server iOS device (the one you're using, if that's you).
    /*________________________________
     | Takes a photo programmatically. |
     --------------------------------*/
    sleep(1); //For some reason, capturing a still image does not work unless there is a small delay.
    [cam capturePicture]; //Capture still image.
    
}

// Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	//Convert received NSData to NSString to display
   	NSString *whatDidIGet = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	//Dsiplay the data as a UIAlertView
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Received" message:whatDidIGet delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
    
    //If the msg was to take a picture.
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

}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
    self.dataSession = session;
    
	switch(state){
        //Other Device Found, attempt to connect.
        case GKPeerStateAvailable:
        {

                //A device in the area was found. Connect.
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
        //Device connected to server.
        case GKPeerStateConnected:
        {
            NSLog(@"Client connected!");
            //Used to acknowledge that we will be sending data
            [session setDataReceiveHandler:self withContext:nil];
            
            //Add the peer to the dataPeers Array
            [dataPeers addObject:peerID];
        
            NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            //Remove the connection buttons.
            [[self.view viewWithTag:11] removeFromSuperview];
            [[self.view viewWithTag:12] removeFromSuperview];
            
            //Add capture request button. When pressed, all devices will take a picture.
            UIButton *btnRequest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btnRequest addTarget:self action:@selector(requestCapture:) forControlEvents:UIControlEventTouchUpInside];
            [btnRequest setTitle:@"Request Camera Shot" forState:UIControlStateNormal];
            btnRequest.frame = CGRectMake(20, 150, 280, 30);
            btnRequest.tag = 13;
            [self.view addSubview:btnRequest];
        }
            break;
        //Device disconnected.
        case GKPeerStateDisconnected:
        {
            NSLog(@"Client Disconnected.");
        }
            break;
        //Device unavailable.
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
    
    //If you want to implement acceptance/rejection of connections, use this template. If not, ignore.
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Request" message:[NSString stringWithFormat:@"The Client %@ is trying to connect.", peerName] delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
    [alert show];

    if(selection == @"accept"){
        [session acceptConnectionFromPeer:peerID error:nil];
    }else{
        [session denyConnectionFromPeer:peerID];
    }*/
    
    [session acceptConnectionFromPeer:peerID error:nil];
    
}

@end
