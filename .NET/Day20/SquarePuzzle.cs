using System;
using System.Collections.Generic;
using System.Linq;

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
                    var topMatchFound = otherPieces.Any(p => p.BorderIds.Contains(piece.TopBorderId) || p.FlippedBorderIds.Contains(piece.TopBorderId)) ? 1 : 0;
                    var rightMatchFound = otherPieces.Any(p => p.BorderIds.Contains(piece.RightBorderId) || p.FlippedBorderIds.Contains(piece.RightBorderId)) ? 1 : 0;
                    var bottomMatchFound = otherPieces.Any(p => p.BorderIds.Contains(piece.BottomBorderId) || p.FlippedBorderIds.Contains(piece.BottomBorderId)) ? 1 : 0;
                    var leftMatchFound = otherPieces.Any(p => p.BorderIds.Contains(piece.LeftBorderId) || p.FlippedBorderIds.Contains(piece.LeftBorderId)) ? 1 : 0;
                    var totalSidesFound = topMatchFound + rightMatchFound + bottomMatchFound + leftMatchFound;

                    if (totalSidesFound == 2)
                    {
                        cornerPieces.Add(piece);
                    }
                }

                return cornerPieces;
            }
        }
    }
}
