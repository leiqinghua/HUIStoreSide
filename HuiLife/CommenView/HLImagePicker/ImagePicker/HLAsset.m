//
//  HLAsset.m
//  HuiLife
//
//  Created by 王策 on 2019/11/6.
//

#import "HLAsset.h"
#import "HLImagePickerService.h"

@implementation HLAsset
//
//-(void)dealloc{
//    NSLog(@"HLAsset dealloc");
//}

- (UIImage *)orignImage
{
    if (_orignImage) {
        return _orignImage;
    }
    
    __block UIImage *resultImage;
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeDefault
                                                  options:phImageRequestOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                resultImage = result;
                                            }];
    _orignImage = resultImage;
    return resultImage;
}

@end

@implementation HLAlbum

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets {
    _result = result;
    if (needFetchAssets) {
        [HLImagePickerService getAssetsFromFetchResult:result completion:^(NSArray<HLAsset *> * models) {
            self->_models = models;
            if (self->_selectedModels) {
                [self checkSelectedModels];
            }
        }];
    }
}

- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableSet *selectedAssets = [NSMutableSet setWithCapacity:_selectedModels.count];
    for (HLAsset *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (HLAsset *model in _models) {
        if ([selectedAssets containsObject:model.asset]) {
            self.selectedCount++;
        }
    }
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return @"";
}

@end
