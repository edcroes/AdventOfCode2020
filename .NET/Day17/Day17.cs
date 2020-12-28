using System.Collections.Generic;
using System.IO;
using AoC2020.Common.Maps;

namespace AoC2020.Day17
{
    public class Day17 : IMDay
    {
        private readonly Map3D<bool> _mapPart1;
        private readonly Map4D<bool> _mapPart2;
        private const int Cycles = 6;

        public Day17()
        {
            var input = File.ReadAllLines("Day17\\input.txt");
            var xExpandsToMax = input[0].Length + (Cycles * 2);
            var yExpandsToMax = input.Length + (Cycles * 2);
            var zExpandsToMax = 1 + (Cycles * 2);
            var initialMap = ParseInitialMap(input, '#');

            _mapPart1 = new Map3D<bool>(xExpandsToMax, yExpandsToMax, zExpandsToMax);
            _mapPart1.PlaceInMiddle(initialMap);

            _mapPart2 = new Map4D<bool>(xExpandsToMax, yExpandsToMax, zExpandsToMax, zExpandsToMax);
            _mapPart2.PlaceInMiddle(initialMap);
        }

        private static bool[,] ParseInitialMap(string[] lines, char trueValue)
        {
            var map = new bool[lines.Length, lines[0].Length];

            for (int y = 0; y < lines.Length; y++)
            {
                for (int x = 0; x < lines[0].Length; x++)
                {
                    map[y, x] = lines[y][x] == trueValue;
                }
            }

            return map;
        }

        public string GetAnswerPart1()
        {
            for (int cycle = 0; cycle < Cycles; cycle++)
            {
                _mapPart1.DistributeChaos(true, (alive, neighborMatches, currentValue) =>
                {
                    if ((alive && (neighborMatches < 2 || neighborMatches > 3)) ||
                        (!alive && neighborMatches == 3))
                    {
                        return !currentValue;
                    }
                    return currentValue;
                });
            }

            return _mapPart1.Count(true).ToString();
        }

        public string GetAnswerPart2()
        {
            for (int cycle = 0; cycle < Cycles; cycle++)
            {
                _mapPart2.DistributeChaos(true, (alive, neighborMatches, currentValue) =>
                {
                    if ((alive && (neighborMatches < 2 || neighborMatches > 3)) ||
                        (!alive && neighborMatches == 3))
                    {
                        return !currentValue;
                    }
                    return currentValue;
                });
            }

            return _mapPart2.Count(true).ToString();
        }
    }
}
