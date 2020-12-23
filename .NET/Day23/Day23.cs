using System.Linq;
using AoC2020.Common;

namespace AoC2020.Day23
{
    public class Day23 : IMDay
    {
        public string GetAnswerPart1()
        {
            var input = "364289715";
            var cups = input.ToCharArray().Select(c => int.Parse(c.ToString())).ToArray();
            var allCups = ParseCups(cups);

            PlayGame(allCups, cups[0], 100);

            var result = string.Empty;
            var currentCup = allCups[0].Next;
            while (currentCup.Value != 1)
            {
                result += currentCup.Value;
                currentCup = currentCup.Next;
            }

            return result;
        }

        public string GetAnswerPart2()
        {
            var input = "364289715";
            var cups = input.ToCharArray().Select(c => int.Parse(c.ToString())).ToArray();
            var allCups = ParseCups(cups, 1000000);

            PlayGame(allCups, cups[0], 10000000);

            return $"{(long)allCups[0].Next.Value * (long)allCups[0].Next.Next.Value}";
        }

        private LinkedItem<int>[] ParseCups(int[] cups, int addUpToCups = 0)
        {
            var allCups = new LinkedItem<int>[addUpToCups < cups.Length ? cups.Length : addUpToCups];

            LinkedItem<int> first = null;
            LinkedItem<int> previous = null;

            foreach (var cupValue in cups)
            {
                var cup = new LinkedItem<int> { Value = cupValue };
                allCups[cup.Value - 1] = cup;

                if (previous == null)
                {
                    first = cup;
                }
                else
                {
                    previous.Next = cup;
                }
                previous = cup;
            }

            if (addUpToCups != 0)
            {
                var cupValue = cups.OrderByDescending(c => c).First();

                while (++cupValue <= addUpToCups)
                {
                    var cup = new LinkedItem<int> { Value = cupValue };
                    allCups[cup.Value - 1] = cup;
                    previous.Next = cup;
                    previous = cup;
                }
            }

            previous.Next = first;

            return allCups;
        }

        private void PlayGame(LinkedItem<int>[] allCups, int firstCup, int moves)
        {
            var currentCup = allCups[firstCup - 1];
            for (var move = 0; move < moves; move++)
            {
                var nextAfterCurrent = currentCup.Next.Next.Next.Next;
                var placeAfterCup = currentCup.Value == 1 ? allCups.Length : currentCup.Value - 1;
                while (currentCup.Next.Value == placeAfterCup || currentCup.Next.Next.Value == placeAfterCup || currentCup.Next.Next.Next.Value == placeAfterCup)
                {
                    placeAfterCup = placeAfterCup == 1 ? allCups.Length : placeAfterCup - 1;
                }

                currentCup.Next.Next.Next.Next = allCups[placeAfterCup - 1].Next;
                allCups[placeAfterCup - 1].Next = currentCup.Next;
                currentCup.Next = nextAfterCurrent;
                currentCup = currentCup.Next;
            }
        }
    }
}
