namespace AoC2020.Day25
{
    public class Day25 : IMDay
    {
        public string GetAnswerPart1()
        {
            var divider = 20201227;
            var cardPublicKey = 17607508;
            var doorPublicKey = 15065270;
            var cardPrivateKey = BruteForcePrivateKey(7, cardPublicKey, divider);
            var doorPrivateKey = BruteForcePrivateKey(7, doorPublicKey, divider);

            var key = doorPrivateKey < cardPrivateKey
                ? GetEncryptionKey(cardPublicKey, doorPrivateKey, divider)
                : GetEncryptionKey(doorPublicKey, cardPrivateKey, divider);

            return key.ToString();
        }

        public string GetAnswerPart2()
        {
            return "There is no part 2...";
        }

        private int BruteForcePrivateKey(int subject, int publicKey, int divider)
        {
            var remainder = 1;
            var privateKey = 0;

            while (remainder != publicKey)
            {
                privateKey++;
                remainder = remainder * subject % divider;
            }

            return privateKey;
        }

        private long GetEncryptionKey(int otherPublicKey, int yourPrivateKey, int divider)
        {
            var encryptionKey = 1L;
            for (var i = 0; i < yourPrivateKey; i++)
            {
                encryptionKey = encryptionKey * otherPublicKey % divider;
            }

            return encryptionKey;
        }
    }
}
