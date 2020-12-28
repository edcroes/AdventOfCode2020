using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using AoC2020.Common.Maps;

namespace AoC2020.Day24
{
    public class Day24 : IMDay
    {
        private readonly string[] _input;

        public Day24()
        {
            _input = File.ReadAllLines("Day24\\input.txt");
        }

        public string GetAnswerPart1()
        {
            var grid = PrepareGrid(_input);
            return grid.Count(true).ToString();
        }

        public string GetAnswerPart2()
        {
            var grid = PrepareGrid(_input);

            for (var day = 1; day <= 100; day++)
            {
                grid.DistributeChaos(true, (isAlive, neighborMatches) =>
                (
                    (!isAlive && neighborMatches == 2) ||
                    (isAlive && neighborMatches > 0 && neighborMatches <= 2)
                ));
            }

            return grid.Count(true).ToString();
        }

        private static RowsHexGrid<bool> PrepareGrid(string[] input)
        {
            var allInstructions = new List<HexGridDirection[]>();
            var longestInstructions = 0;
            foreach (var line in input)
            {
                var instructions = ParseInstructions(line);
                allInstructions.Add(instructions);

                if (longestInstructions < instructions.Length)
                {
                    longestInstructions = instructions.Length;
                }
            }

            var gridSize = longestInstructions * 2 + 1;
            var grid = new RowsHexGrid<bool>(gridSize, gridSize, true);
            var startingPoint = new Point(longestInstructions, longestInstructions);

            foreach (var instructionSet in allInstructions)
            {
                grid.SetCurrentPosition(startingPoint);
                foreach (var instruction in instructionSet)
                {
                    grid.MoveCurrentPosition(instruction);
                }
                grid.SetValue(grid.CurrentPosition, !grid.GetValue(grid.CurrentPosition));
            }

            return grid;
        }

        private static HexGridDirection[] ParseInstructions(string line)
        {
            return line
                .Replace("ne", "u")
                .Replace("nw", "y")
                .Replace("se", "j")
                .Replace("sw", "h")
                .ToCharArray()
                .Select(c => GetDirection(c))
                .ToArray();
        }

        private static HexGridDirection GetDirection(char c)
        {
            return c switch
            {
                'u' => HexGridDirection.NorthEast,
                'y' => HexGridDirection.NorthWest,
                'j' => HexGridDirection.SouthEast,
                'h' => HexGridDirection.SouthWest,
                'e' => HexGridDirection.East,
                'w' => HexGridDirection.West,
                _ => throw new ArgumentException("Unknown direction")
            };
        }
    }
}
