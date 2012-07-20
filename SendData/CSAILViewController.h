//
//  CSAILViewController.h
//  SendData
//
//  Created by Grace Christenbery on 7/18/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import <UIKit/UIKit.h>
//A. Import GameKit Framework
#import <GameKit/GameKit.h>
//B. Subclass GKSessionDelegate and GKPeerPickerControllerDelegate
//      GKSessionDelegate: Used to maintain Sessions
//      GKPeerPickerControllerDelegate: Gives an Apple provided peer picker,
//            where you can look for other devices using the same apps to connect with.
//            For now, we actually won't use this and will implement our own UI elements.
//            This is because we are using a client-server model, which the PeerPickerController does not work with.
//            Why? The client-server model allows ≥ 3 connections simultaneously, where as the peer-to-peer model only
//            allows 2 devices to connect at once.

@interface CSAILViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate>{
//C. Create the following objects.
    //Connection session.
    GKSession *dataSession;

    //Array of peers connected
    NSMutableArray *dataPeers;
    
    BOOL isHost;
    
}

@property (retain) GKSession *dataSession;

//D. Methods to connect and send data.
- (void) connectToPeers:(id)sender;
- (void) requestCapture:(id)sender;


@end
