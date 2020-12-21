using System;
using System.Collections.Generic;
using System.Linq;
using AoC2020.Common.Maps;

namespace AoC2020.Day20
{
    public class SquarePuzzle
    {
        private List<PuzzlePiece> _pieces;

        public SquarePuzzle(IEnumerable<PuzzlePiece> pieces)
        {
            _pieces = pieces.ToList();
        }

        public IEnumerable<PuzzlePiece> CornerPieces
        {
            get
            {
                var cornerPieces = new List<PuzzlePiece>();
                foreach (var piece in _pieces)
                {
                    var otherPieces = _pieces.Where(p => p != piece);
                    var topMatchFound = otherPieces.Any(p => p.BorderIds.Contains(piece.TopBorderId)) ? 1 : 0;
                    var rightMatchFound = otherPieces.Any(p => p.BorderIds.Contains(piece.RightBorderId)) ? 1 : 0;
                    var bottomMatchFound = otherPieces.Any(p => p.BorderIds.Contains(piece.BottomBorderId)) ? 1 : 0;
                    var leftMatchFound = otherPieces.Any(p => p.BorderIds.Contains(piece.LeftBorderId)) ? 1 : 0;
                    var totalSidesFound = topMatchFound + rightMatchFound + bottomMatchFound + leftMatchFound;

                    if (totalSidesFound == 2)
                    {
                        cornerPieces.Add(piece);
                    }
                }

                return cornerPieces;
            }
        }

        public Map<bool> SolveWithoutBorders()
        {
            return GetCompletedPictureWithoutBorders(SolvePuzzle());
        }

        public Map<bool> SolveWithBorders()
        {
            return GetCompletedPictureWithBorders(SolvePuzzle());
        }

        private Map<PuzzlePiece> SolvePuzzle()
        {
            var sideLength = (int)Math.Sqrt(_pieces.Count);
            var puzzleMap = new Map<PuzzlePiece>(sideLength, sideLength);

            var firstPiece = CornerPieces.First();
            var piecesLeft = _pieces.Where(p => p != firstPiece);

            while (!piecesLeft.Any(p => p.BorderIds.Contains(firstPiece.RightBorderId)) || !piecesLeft.Any(p => p.BorderIds.Contains(firstPiece.BottomBorderId)))
            {
                firstPiece.RotateRight();
            }
            puzzleMap.SetValue(0, 0, firstPiece);

            for (var y = 0; y < sideLength; y++)
            {
                for (var x = 0; x < sideLength; x++)
                {
                    if (x == 0 && y == 0) continue;

                    var nextPiece = x == 0
                        ? FindConnectingPieceByOneSideAndPlaceInCorrectPosition(piecesLeft, PuzzlePiece.Border.Top, puzzleMap.GetValue(x, y - 1).BottomBorderId)
                        : FindConnectingPieceByOneSideAndPlaceInCorrectPosition(piecesLeft, PuzzlePiece.Border.Left, puzzleMap.GetValue(x - 1, y).RightBorderId);

                    puzzleMap.SetValue(x, y, nextPiece);
                    piecesLeft = piecesLeft.Where(p => p != nextPiece);

                }
            }

            return puzzleMap;
        }

        private Map<bool> GetCompletedPictureWithBorders(Map<PuzzlePiece> solvedPuzzle)
        {
            var xPerPiece = solvedPuzzle.GetValue(0, 0).Picture.SizeX;
            var yPerPiece = solvedPuzzle.GetValue(0, 0).Picture.SizeY;
            var sizeX = solvedPuzzle.SizeX * xPerPiece;
            var sizeY = solvedPuzzle.SizeY * yPerPiece;
            var completedPuzzle = new Map<bool>(sizeX, sizeY);

            for (var pieceY = 0; pieceY < solvedPuzzle.SizeY; pieceY++)
            {
                for (var pieceX = 0; pieceX < solvedPuzzle.SizeX; pieceX++)
                {
                    var currentPiece = solvedPuzzle.GetValue(pieceX, pieceY);
                    var startX = xPerPiece * pieceX;
                    var startY = yPerPiece * pieceY;

                    for (var y = 0; y < currentPiece.Picture.SizeY; y++)
                    {
                        for (var x = 0; x < currentPiece.Picture.SizeX; x++)
                        {
                            completedPuzzle.SetValue(startX + x, startY + y, currentPiece.Picture.GetValue(x, y));
                        }
                    }
                }
            }

            return completedPuzzle;
        }

        private Map<bool> GetCompletedPictureWithoutBorders(Map<PuzzlePiece> solvedPuzzle)
        {
            var xPerPiece = solvedPuzzle.GetValue(0, 0).Picture.SizeX - 2;
            var yPerPiece = solvedPuzzle.GetValue(0, 0).Picture.SizeY - 2;
            var sizeX = solvedPuzzle.SizeX * xPerPiece;
            var sizeY = solvedPuzzle.SizeY * yPerPiece;
            var completedPuzzle = new Map<bool>(sizeX, sizeY);

            for (var pieceY = 0; pieceY < solvedPuzzle.SizeY; pieceY++)
            {
                for (var pieceX = 0; pieceX < solvedPuzzle.SizeX; pieceX++)
                {
                    var currentPiece = solvedPuzzle.GetValue(pieceX, pieceY);
                    var startX = xPerPiece * pieceX;
                    var startY = yPerPiece * pieceY;

                    for (var y = 1; y < currentPiece.Picture.SizeY - 1; y++)
                    {
                        for (var x = 1; x < currentPiece.Picture.SizeX - 1; x++)
                        {
                            completedPuzzle.SetValue(startX + x - 1, startY + y - 1, currentPiece.Picture.GetValue(x, y));
                        }
                    }
                }
            }

            return completedPuzzle;
        }

        private static PuzzlePiece FindConnectingPieceByOneSideAndPlaceInCorrectPosition(IEnumerable<PuzzlePiece> piecesLeft, PuzzlePiece.Border borderToMatch, short idToMatch)
        {
            var connectingPiece = piecesLeft.Single(p => p.BorderIds.Contains(idToMatch));
            var flippedBorderToMatch = GetFlippedBorder(borderToMatch);
            while (connectingPiece.GetBorderId(borderToMatch) != idToMatch && connectingPiece.GetBorderId(flippedBorderToMatch) != idToMatch)
            {
                connectingPiece.RotateRight();
            }

            if (connectingPiece.GetBorderId(borderToMatch) != idToMatch)
            {
                if (borderToMatch == PuzzlePiece.Border.Left || borderToMatch == PuzzlePiece.Border.Right)
                {
                    connectingPiece.MirrorVertical();
                }
                else
                {
                    connectingPiece.MirrorHorizontal();
                }
            }

            return connectingPiece;
        }

        private static PuzzlePiece.Border GetFlippedBorder(PuzzlePiece.Border border)
        {
            if (border == PuzzlePiece.Border.None)
            {
                return border;
            }

            var id = (int)border > 3 ? (int)border - 4 : (int)border + 4;
            return (PuzzlePiece.Border)id;
        }
    }
}
