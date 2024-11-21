public class MessageTriggerHandler {
    
    public static String maskCreditCardNumbers(String inputText) {
        if (String.isBlank(inputText)) {
            return inputText;
        }

        Pattern cardPattern = Pattern.compile('\\b(?:\\d[ -]*?){13,16}\\b');
        Matcher matcher = cardPattern.matcher(inputText);
        String modifiedText = inputText;
        
        // Loop through all matches found by the regex
        while (matcher.find()) {
            String potentialCardNumber = matcher.group(0).replaceAll('[-\\s]', ''); // Remove spaces or dashes

            // Validate the detected number using Luhn algorithm
            if (isValidCreditCard(potentialCardNumber)) {
                // Mask the valid credit card number and keep only the last 4 digits visible
                String maskedCardNumber = maskCreditCard(potentialCardNumber);
                modifiedText = modifiedText.replace(matcher.group(0), maskedCardNumber);
            }
        }
        return modifiedText;
    }

    private static String maskCreditCard(String cardNumber) {
        if (cardNumber.length() < 4) {
            return cardNumber;
        }

        // Create a string with '-' for all but the last 4 digits
        String masked = generateMask(cardNumber.length() - 4);

        // Append the last 4 digits of the card number
        masked = masked + cardNumber.substring(cardNumber.length() - 4);
        return masked.trim(); // Trim any trailing space
    }

    // Generate a string with repeated '-' characters for masking
    private static String generateMask(Integer length) {
        String mask = '';
        for (Integer i = 0; i < length; i++) {
            mask += '-';
        }
        return mask;
    }

    // Validate the credit card number using the Luhn algorithm
    private static Boolean isValidCreditCard(String cardNumber) {
        Integer sum = 0;
        Boolean alternate = false;

        for (Integer i = cardNumber.length() - 1; i >= 0; i--) {
            Integer n = Integer.valueOf(cardNumber.substring(i, i + 1));
            if (alternate) {
                n *= 2;
                if (n > 9) n -= 9; // Subtract 9 if doubling results in a value greater than 9
            }
            sum += n;
            alternate = !alternate;
        }

        // Check if the sum is a multiple of 10 using Math.mod
        return Math.mod(sum, 10) == 0;
    }
}