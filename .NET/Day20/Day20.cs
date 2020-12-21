using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using AoC2020.Common.Maps;

namespace AoC2020.Day20
{
    public class Day20 : IMDay
    {
        private readonly SquarePuzzle _puzzle;

        public Day20()
        {
            var input = File.ReadAllText("Day20\\input.txt");
            _puzzle = new SquarePuzzle(ParseInput(input));
        }

        public string GetAnswerPart1()
        {
            var result = _puzzle.CornerPieces.Aggregate(1L, (result, item) => result * item.Id);
            return result.ToString();
        }

        public string GetAnswerPart2()
        {
            return "Not Implemented";
        }

        private static List<PuzzlePiece> ParseInput(string input)
        {
            var pieces = new Dictionary<int, Map<bool>>();
            var parts = input.Replace("\r", "").Split("\n\n", StringSplitOptions.RemoveEmptyEntries);

            return parts.Select(p => PuzzlePiece.ParsePiece(p)).ToList();
        }
    }
}
