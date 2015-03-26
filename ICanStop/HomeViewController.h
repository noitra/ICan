//
//  HomeViewController.h
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property(nonatomic, weak) IBOutlet UIButton *button;
@property(nonatomic, strong) NSArray * items;
@property(nonatomic) BOOL isCounting;
@property(nonatomic) NSDate *dataInicial;
@property(nonatomic) NSDate *dataFinal;
@property(nonatomic, weak) IBOutlet UILabel *tempo;
@property(nonatomic, weak) IBOutlet UILabel *escolha_vicio;
@property(nonatomic, weak) IBOutlet UILabel *escolha_horario;
@property(nonatomic, weak) IBOutlet UILabel *welcome;
@property(nonatomic, weak) IBOutlet UIImageView *imagem_vicio;


@end
