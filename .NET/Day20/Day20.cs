using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
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
            var noOfMonsterPieces = 15;
            var resultingImage = _puzzle.SolveWithoutBorders();

            var monsterCount = SearchForMonsters(resultingImage);
            if (monsterCount == 0)
            {
                resultingImage.MirrorHorizontal();
                monsterCount = SearchForMonsters(resultingImage);
            }

            var waterRoughness = resultingImage.Count(true) - monsterCount * noOfMonsterPieces;

            return $"{waterRoughness} (found {monsterCount} monsters)";
        }

        private static List<PuzzlePiece> ParseInput(string input)
        {
            var pieces = new Dictionary<int, Map<bool>>();
            var parts = input.Replace("\r", "").Split("\n\n", StringSplitOptions.RemoveEmptyEntries);

            return parts.Select(p => PuzzlePiece.ParsePiece(p)).ToList();
        }

        private static int SearchForMonsters(Map<bool> image)
        {
            var monstersFound = 0;
            var monsterLength = 20;
            var head = new Regex(".{18}#");
            var upperBody = new Regex("#.{4}##.{4}##.{4}###");
            var lowerBody = new Regex(".#.{2}#.{2}#.{2}#.{2}#.{2}#");

            var imageDump = DumpImage(image);

            for (var side = 0; side < 4; side++)
            {
                for (int y = 1; y < imageDump.Length - 1; y++)
                {
                    var matches = upperBody.Matches(imageDump[y]);
                    if (matches.Count > 0)
                    {
                        foreach (Match match in matches)
                        {
                            if (head.IsMatch(imageDump[y - 1].Substring(match.Index, monsterLength)) &&
                                lowerBody.IsMatch(imageDump[y + 1].Substring(match.Index, monsterLength)))
                            {
                                monstersFound++;
                            }
                        }
                    }
                }

                if (monstersFound > 0)
                {
                    break;
                }
                else
                {
                    image.RotateRight();
                    imageDump = DumpImage(image);
                }
            }

            return monstersFound;
        }

        private static string[] DumpImage(Map<bool> image)
        {
            var result = new string[image.SizeY];
            for (var y = 0; y < image.SizeY; y++)
            {
                var line = string.Empty;
                for (var x = 0; x < image.SizeX; x++)
                {
                    line += image.GetValue(x, y) ? "#" : ".";
                }
                result[y] = line;
            }

            return result;
        }
    }
}
