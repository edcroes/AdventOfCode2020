using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;

namespace AoC2020.Common.Maps
{
    public abstract class HexGridBase<T>
    {
        protected Map<T> _grid;
        protected Point _currentPosition = new Point(0, 0);

        public int SizeX => _grid.SizeX;
        public int SizeY => _grid.SizeY;
        public Point CurrentPosition => _currentPosition;

        public HexGridBase(int x, int y)
        {
            _grid = new Map<T>(x, y);
        }

        public abstract void MoveCurrentPosition(HexGridDirection direction);

        public void SetCurrentPosition(Point point)
        {
            if (point.X >= SizeX || point.Y >= SizeY || point.X < 0 || point.Y < 0)
            {
                throw new IndexOutOfRangeException("That point is not within the hexgrid.");
            }
            _currentPosition = point;
        }

        public T GetValue(Point point)
        {
            return _grid.GetValue(point.X, point.Y);
        }

        public void SetValue(Point point, T value)
        {
            _grid.SetValue(point.X, point.Y, value);
        }

        public int Count(T valueToMatch)
        {
            return _grid.Count(valueToMatch);
        }

        public void DistributeChaos(T aliveValue, Func<bool, int, T> getNewValue)
        {
            if (ShouldExpand(aliveValue))
            {
                Expand();
            }
            var pointsToChange = new Dictionary<Point, T>();

            for (int y = 0; y < SizeY; y++)
            {
                for (int x = 0; x < SizeX; x++)
                {
                    var currentPoint = new Point(x, y);
                    var currentValue = GetValue(currentPoint);
                    var matches = NumberOfNeighborsThatMatch(currentPoint, aliveValue);

                    var newValue = getNewValue(aliveValue.Equals(currentValue), matches);
                    if (!newValue.Equals(currentValue))
                    {
                        pointsToChange.Add(currentPoint, newValue);
                    }
                }
            }

            foreach (var point in pointsToChange.Keys)
            {
                SetValue(point, pointsToChange[point]);
            }
        }

        public abstract int NumberOfNeighborsThatMatch(Point point, T aliveValue);

        private bool ShouldExpand(T aliveValue)
        {
            return
                _grid.GetLine(0, 0, 0, SizeY - 1).Any(v => aliveValue.Equals(v)) ||
                _grid.GetLine(SizeX - 1, 0, SizeX - 1, SizeY - 1).Any(v => aliveValue.Equals(v)) ||
                _grid.GetLine(0, 0, SizeX - 1, 0).Any(v => aliveValue.Equals(v)) ||
                _grid.GetLine(0, SizeY - 1, SizeX - 1, SizeY - 1).Any(v => aliveValue.Equals(v));
        }

        private void Expand()
        {
            var newGrid = new Map<T>(SizeX + 4, SizeY + 4);
            _grid.CopyTo(newGrid, new Point(2, 2));
            _grid = newGrid;
        }
    }
}
