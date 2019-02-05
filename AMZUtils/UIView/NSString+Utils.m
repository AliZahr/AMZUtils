#import "NSString+Utils.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (Utils)

- (int)extractNumber
{
    NSString *numberString;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    int number = [numberString intValue];
    return number;
}


- (NSArray *)extractNumbers
{
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    NSString *numberString;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *filter = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        numberString = @"";
        [scanner scanUpToCharactersFromSet:filter intoString:NULL];
        if([scanner scanCharactersFromSet:filter intoString:&numberString])
        {
            [numbers addObject:[NSNumber numberWithInt:[numberString intValue]]];
        }
    }
    
    NSArray *array = [[NSArray alloc] initWithArray:numbers];
    return array;
}

-(BOOL) IsValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL) isValidPhoneNumber
{
    if (nil == self || ([self length] < 2 ) )
        return NO;
    
    NSError *error;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    NSArray *matches = [detector matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypePhoneNumber) {
            NSString *phoneNumber = [match phoneNumber];
            if ([self isEqualToString:phoneNumber]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSMutableAttributedString*)getColoredPercentageWithColor:(UIColor*)color
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self attributes:nil];
    NSString *newString = [[self componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    NSString *percentage = [NSString stringWithFormat:@"%@%%",newString];
    NSRange range = [self rangeOfString:percentage options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return attrStr;
}

- (NSString *)urlencode
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSString *)extractLettersOnlyString
{
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] componentsJoinedByString:@" "];
}

- (NSString*)GetNameWithoutSpecialCharacters
{
    NSString *separatorString = @"-";
    NSString *name = [self componentsSeparatedByString:separatorString].firstObject;
    
    return name;
}

- (NSString*)trimLeadingTrailingSpaces
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*)hashValue
{
    const char* str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
