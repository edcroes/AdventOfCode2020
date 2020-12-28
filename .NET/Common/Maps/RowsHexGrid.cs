using System;
using System.Drawing;
using System.Linq;

namespace AoC2020.Common.Maps
{
    public class RowsHexGrid<T> : HexGridBase<T>
    {
        private static readonly HexGridDirection[] ValidDirections = new[]
        {
            HexGridDirection.East,
            HexGridDirection.West,
            HexGridDirection.NorthEast,
            HexGridDirection.NorthWest,
            HexGridDirection.SouthEast,
            HexGridDirection.SouthWest
        };
        private readonly bool _evenRowsRight;

        public RowsHexGrid(int x, int y, bool evenRowsRight) : base(x, y)
        {
            _evenRowsRight = evenRowsRight;
        }

        public override void MoveCurrentPosition(HexGridDirection direction)
        {
            _currentPosition = GetNeighborPosition(_currentPosition, direction);
        }

        public override int NumberOfNeighborsThatMatch(Point point, T aliveValue)
        {
            return ValidDirections.Count(d => aliveValue.Equals(GetNeighborValue(point, d)));
        }

        private T GetNeighborValue(Point point, HexGridDirection direction)
        {
            var neighborPosition = GetNeighborPosition(point, direction);
            if (neighborPosition.X < 0 || neighborPosition.X >= SizeX || neighborPosition.Y < 0 || neighborPosition.Y >= SizeY)
            {
                return default;
            }

            return GetValue(neighborPosition);
        }

        private Point GetNeighborPosition(Point point, HexGridDirection direction)
        {
            var moveX = (IsRowEven(point.Y) && _evenRowsRight) || (!IsRowEven(point.Y) && !_evenRowsRight) ? 0 : -1;

            var movePosition = direction switch
            {
                HexGridDirection.East => new Point(1, 0),
                HexGridDirection.West => new Point(-1, 0),
                HexGridDirection.NorthEast => new Point(1 + moveX, -1),
                HexGridDirection.SouthEast => new Point(1 + moveX, 1),
                HexGridDirection.SouthWest => new Point(0 + moveX, 1),
                HexGridDirection.NorthWest => new Point(0 + moveX, -1),
                _ => throw new ArgumentException("You cannot move North or South in a row based hexgrid.")
            };

            return new Point(point.X + movePosition.X, point.Y + movePosition.Y);
        }

        private static bool IsRowEven(int row) => row % 2 == 0;
    }
}
