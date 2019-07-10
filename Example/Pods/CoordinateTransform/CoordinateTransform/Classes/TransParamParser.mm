//
//  TransParamParser.m
//  SQLiteSpatialite
//
//  Created by iefmac004 on 13-1-4.
//  Copyright (c) 2013年 iefmac004. All rights reserved.
//
#import "TransParamParser.h"

@implementation TransParamParser
@synthesize error=_error;
@synthesize lods =_lods;
@synthesize lastElement=_lastElement;
@synthesize currenElementName;
-(void)startParsing:(NSString *)filePath
{
    NSData* xmlFileData = [[NSData alloc]initWithContentsOfFile:filePath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlFileData];
    [self startParsingWithParser:xmlParser];
}

- (void)startParsingWithParser:(NSXMLParser *)parser {
    self.lods = [NSMutableArray array];
    _xmlParser = parser;
    _xmlParser.delegate = self;
    if (![_xmlParser parse]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"文件解析失败" message:@"文件不存在或者文件已经损坏！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(TWOPARAM)getTWOPARAM
{
    return twoparam;
}
-(FOURPARAM)getFOURPARAM
{
    return fourparam;
}
-(SEVENPARAM)getSEVENPARAM
{
    return sevenparam;
}

-(SIXPARAM)getSIXPARAM
{
    return sixparam;
}
-(SEVEN_FOUR)getSEVEN_FOUR
{
    return sevenfour;
}
-(SEVEN_PARAM_REV)getSEVEN_PARAM_REV
{
    return sevenparamrev;
}
-(double)getEllipseType
{
    return ellipseType;
}
-(double)getMiddleLine
{
    return middleLine;
}
-(double)getTransType
{
    return transType;
}
-(double)getRev
{
    return rev;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //Save the error
    self.error = parseError;
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"TransParams"])
    {
        self.lods = [[NSMutableArray alloc]init];
    }
    currenElementName = elementName;
}
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    double temp=0;
    NSString *elementName = currenElementName;
    temp = [string doubleValue];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([elementName isEqualToString:@"two_param"])
    {
        _lastElement = @"two_param";
    }
    else if ([elementName isEqualToString:@"four_param"])
    {
        _lastElement = @"four_param";
    }
    else if ([elementName isEqualToString:@"six_param"])
    {
        _lastElement = @"six_param";
    }
    else if ([elementName isEqualToString:@"seven_param"])
    {
        _lastElement = @"seven_param";
    }
    else if ([elementName isEqualToString:@"seven_four"])
    {
        _lastElement = @"seven_four";
    }
    else if ([elementName isEqualToString:@"seven_param_rev"])
    {
        _lastElement = @"seven_param_rev";
    }
    
    if ([string length] < 1 || ![self isPureFloat:string])
    {
        return;
    }
    else if ([elementName isEqualToString:@"ellipseType"])
    {
        ellipseType = temp;
    } else if ([elementName isEqualToString:@"middleLine"])
    {
        middleLine = temp;
    } else if ([elementName isEqualToString:@"transType"])
    {
        transType = temp;
    } else if ([elementName isEqualToString:@"rev"])
    {
        rev = temp;
    }else if ([self.lastElement isEqualToString:@"two_param"])
    {
        if ([elementName isEqualToString:@"x_off"])
        {
            twoparam.x_off = temp;
        }else if ([elementName isEqualToString:@"y_off"])
        {
            twoparam.y_off = temp;
        }
    }else if ([self.lastElement isEqualToString:@"four_param"])
    {
        if ([elementName isEqualToString:@"x_off"])
        {
            fourparam.x_off = temp;
        }else if ([elementName isEqualToString:@"y_off"])
        {
            fourparam.y_off = temp;
        }else if ([elementName isEqualToString:@"angle"])
        {
            fourparam.angle = temp;
        }else if ([elementName isEqualToString:@"m"])
        {
            fourparam.m = temp;
        }
    }else if ([self.lastElement isEqualToString:@"six_param"])
    {
        if ([elementName isEqualToString:@"x0_local"])
        {
            sixparam.x0_local = temp;
        }else if ([elementName isEqualToString:@"y0_local"])
        {
            sixparam.y0_local = temp;
        }else if ([elementName isEqualToString:@"x0_gps"])
        {
            sixparam.x0_gps = temp;
        }else if ([elementName isEqualToString:@"y0_gps"])
        {
            sixparam.y0_gps = temp;
        }else if ([elementName isEqualToString:@"angle"])
        {
            sixparam.angle = temp;
        }else if ([elementName isEqualToString:@"m"])
        {
            sixparam.m = temp;
        }
    }else if ([self.lastElement isEqualToString:@"seven_param"])
    {
        if ([elementName isEqualToString:@"x_off"])
        {
            twoparam.x_off = temp;
        }else if ([elementName isEqualToString:@"y_off"])
        {
            twoparam.y_off = temp;
        }else if ([elementName isEqualToString:@"seven_x_off"])
        {
            sevenparam.x_off = temp;
        }else if ([elementName isEqualToString:@"seven_y_off"])
        {
            sevenparam.y_off = temp;
        }else if ([elementName isEqualToString:@"seven_z_off"])
        {
            sevenparam.z_off = temp;
        }else if ([elementName isEqualToString:@"seven_x_angle"])
        {
            sevenparam.x_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_y_angle"])
        {
            sevenparam.y_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_z_angle"])
        {
            sevenparam.z_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_m"])
        {
            sevenparam.m = temp;
        }
    }else if ([self.lastElement isEqualToString:@"seven_four"])
    {
        if ([elementName isEqualToString:@"four_x_off"])
        {
            sevenfour.four_x_off = temp;
        }else if ([elementName isEqualToString:@"four_y_off"])
        {
            sevenfour.four_y_off = temp;
        }else if ([elementName isEqualToString:@"four_angle"])
        {
            sevenfour.four_angle = temp;
        }else if ([elementName isEqualToString:@"four_m"])
        {
            sevenfour.four_m = temp;
        }else if ([elementName isEqualToString:@"seven_x_off"])
        {
            sevenfour.seven_x_off = temp;
        }else if ([elementName isEqualToString:@"seven_y_off"])
        {
            sevenfour.seven_y_off = temp;
        }else if ([elementName isEqualToString:@"seven_z_off"])
        {
            sevenfour.seven_z_off = temp;
        }else if ([elementName isEqualToString:@"seven_x_angle"])
        {
            sevenfour.seven_x_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_y_angle"])
        {
            sevenfour.seven_y_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_z_angle"])
        {
            sevenfour.seven_z_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_m"])
        {
            sevenfour.seven_m = temp;
        }
    }else if ([self.lastElement isEqualToString:@"seven_param_rev"])
    {
        if ([elementName isEqualToString:@"x_off"])
        {
            sevenparamrev.x_off = temp;
        }else if ([elementName isEqualToString:@"y_off"])
        {
            sevenparamrev.y_off = temp;
        }else if ([elementName isEqualToString:@"seven_x_off"])
        {
            sevenparamrev.seven_x_off = temp;
        }else if ([elementName isEqualToString:@"seven_y_off"])
        {
            sevenparamrev.seven_y_off = temp;
        }else if ([elementName isEqualToString:@"seven_z_off"])
        {
            sevenparamrev.seven_z_off = temp;
        }else if ([elementName isEqualToString:@"seven_x_angle"])
        {
            sevenparamrev.seven_x_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_y_angle"])
        {
            sevenparamrev.seven_y_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_z_angle"])
        {
            sevenparamrev.seven_z_angle = temp*PI / 648000;
        }else if ([elementName isEqualToString:@"seven_m"])
        {
            sevenparamrev.seven_m = temp;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"%f",temp);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
}

@end
