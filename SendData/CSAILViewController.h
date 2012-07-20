//
//  CSAILViewController.h
//  SendData
//
//Copyright (c) 2012 Grace Christenbery
//
/*Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/


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
