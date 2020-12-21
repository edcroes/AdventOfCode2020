using System;

namespace AoC2020.Common
{
    public static class BoolArrayExtensions
    {
        public static short ConvertToShort(this bool[] bits)
        {
            if (bits == null)
            {
                return 0;
            }

            if (bits.Length > 16)
            {
                throw new ArgumentException("Bool array is too large for a short.");
            }

            short value = 0;
            for (var i = 16 - bits.Length; i < 16; i++)
            {
                if (bits[i - (16 - bits.Length)])
                {
                    value |= (short)(1 << (15 - i));
                }
            }

            return value;
        }
    }
}