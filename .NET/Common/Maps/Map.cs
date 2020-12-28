using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;

namespace AoC2020.Common.Maps
{
    public class Map<T>
    {
        private T[,] _map;

        public int SizeX => _map.GetLength(1);
        public int SizeY => _map.GetLength(0);

        public Map(int x, int y)
        {
            _map = new T[y, x];
        }

        public T GetValue(int x, int y)
        {
            return _map[y, x];
        }

        public void SetValue(int x, int y, T value)
        {
            _map[y, x] = value;
        }

        public T[] GetLine(int fromX, int fromY, int toX, int toY)
        {
            var row = new List<T>();

            var moveY = fromY == toY ? 0 : fromY > toY ? -1 : 1;
            var moveX = fromX == toX ? 0 : fromX > toX ? -1 : 1;

            do
            {
                row.Add(_map[fromY, fromX]);
                fromY += moveY;
                fromX += moveX;
            }
            while ((fromX <= toX && moveX == 1) || (fromX >= toX && moveX == -1) || (fromY <= toY && moveY == 1) || (fromY >= toY && moveY == -1));

            return row.ToArray();
        }

        public void RotateRight()
        {
            var newMap = new T[SizeX, SizeY];

            for (var y = 0; y < SizeY; y++)
            {
                for (var x = 0; x < SizeX; x++)
                {
                    newMap[x, SizeY - 1 - y] = _map[y, x];
                }
            }

            _map = newMap;
        }

        public void RotateLeft()
        {
            RotateRight();
            RotateRight();
            RotateRight();
        }

        public void MirrorHorizontal()
        {
            var newMap = new T[SizeY, SizeX];

            for (var y = 0; y < SizeY; y++)
            {
                for (var x = 0; x < SizeX; x++)
                {
                    newMap[y, SizeX - 1 - x] = _map[y, x];
                }
            }

            _map = newMap;
        }

        public void MirrorVertical()
        {
            MirrorHorizontal();
            RotateRight();
            RotateRight();
        }

        public int Count(T valueToMatch)
        {
            int count = 0;
            for (int y = 0; y < SizeY; y++)
            {
                for (int x = 0; x < SizeX; x++)
                {
                    if (_map[y, x].Equals(valueToMatch))
                    {
                        count++;
                    }
                }
            }

            return count;
        }

        public void DistributeChaos(T aliveValue, Func<bool, int, T, T> getNewValue)
        {
            var pointsToChange = new Dictionary<Point, T>();

            for (int y = 0; y < SizeY; y++)
            {
                for (int x = 0; x < SizeX; x++)
                {
                    var currentPoint = new Point(x, y);
                    var currentValue = GetValue(currentPoint.X, currentPoint.Y);
                    var matches = NumberOfNeighborsThatMatch(currentPoint, aliveValue);

                    var newValue = getNewValue(aliveValue.Equals(currentValue), matches, currentValue);
                    if (!newValue.Equals(currentValue))
                    {
                        pointsToChange.Add(currentPoint, newValue);
                    }
                }
            }

            foreach (var point in pointsToChange.Keys)
            {
                SetValue(point.X, point.Y, pointsToChange[point]);
            }
        }

        public int NumberOfNeighborsThatMatch(Point point, T valueToMatch)
        {
            var numberOfMatches = 0;
            for (int y = Math.Max(point.Y - 1, 0); y <= point.Y + 1 && y < SizeY; y++)
            {
                for (int x = Math.Max(point.X - 1, 0); x <= point.X + 1 && x < SizeX; x++)
                {
                    if (y == point.Y && x == point.X)
                    {
                        continue;
                    }

                    if (_map[y, x].Equals(valueToMatch))
                    {
                        numberOfMatches++;
                    }
                }
            }

            return numberOfMatches;
        }

        public void CopyTo(Map<T> otherMap, Point startingPoint)
        {
            if (otherMap == null || startingPoint.X + SizeX > otherMap.SizeX || startingPoint.Y + SizeY > otherMap.SizeY)
            {
                throw new IndexOutOfRangeException("The map does not fit the destination");
            }

            for (int y = 0; y < SizeY; y++)
            {
                for (int x = 0; x < SizeX; x++)
                {
                    otherMap.SetValue(x + startingPoint.X, y + startingPoint.Y, GetValue(x, y));
                }
            }
        }
    }
}