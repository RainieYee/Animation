//
//  ThumbCollectionCell.m
//  EXPhotoViewerDemo


#import "ThumbCollectionCell.h"
#import "Animation.h"

@implementation ThumbCollectionCell

- (IBAction)onButtonTUI:(id)sender {
    [Animation showImageFrom:self.thumbnailImage];
}

@end
