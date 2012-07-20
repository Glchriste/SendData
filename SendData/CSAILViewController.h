//
//  CSAILViewController.h
//  SendData
//
//  Created by Grace Christenbery on 7/18/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import <UIKit/UIKit.h>
//1. Import GameKit Framework
#import <GameKit/GameKit.h>
//2. Subclass GKSessionDelegate and GKPeerPickerControllerDelegate
//      GKSessionDelegate - Used to maintain Sessions
//      GKPeerPickerControllerDelegate - Gives an Apple provided peer picker,
//            where you can look for other devices using the same apps to connect with.
@interface CSAILViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate>{
//3. Create the following objects.
    //Connection session.
    GKSession *dataSession;
    //PeerPicker Object
    GKPeerPickerController *dataPicker;
    //Array of peers connected
    NSMutableArray *dataPeers;
    
    BOOL isHost;
    
}

@property (retain) GKSession *dataSession;
//@property (nonatomic, retain) IBOutlet UIButton *seekiOSCameras;

//4. Methods to connect and send data.
- (void) connectToPeers:(id)sender;
- (void) requestCapture:(id)sender;


@end
