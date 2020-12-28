using System;
using System.Collections.Generic;

namespace AoC2020.Common.Maps
{
    class Map4D<T>
    {
        private readonly T[,,,] _map;

        public int SizeX => _map.GetLength(3);
        public int SizeY => _map.GetLength(2);
        public int SizeZ => _map.GetLength(1);
        public int SizeW => _map.GetLength(0);

        public Map4D(int x, int y, int z, int w)
        {
            _map = new T[w, z, y, x];
        }

        public void PlaceInMiddle(T[,] initialState)
        {
            var z = SizeZ / 2;
            var w = SizeW / 2;
            var startY = SizeY / 2 - initialState.GetLength(0) / 2;
            var startX = SizeX / 2 - initialState.GetLength(1) / 2;

            for (int y = 0; y < initialState.GetLength(0); y++)
            {
                for (int x = 0; x < initialState.GetLength(1); x++)
                {
                    _map[w, z, y + startY, x + startX] = initialState[y, x];
                }
            }
        }

        public T GetValue(int x, int y, int z, int w)
        {
            return _map[w, z, y, x];
        }

        public T GetValue(Point4D point)
        {
            return GetValue(point.X, point.Y, point.Z, point.W);
        }

        public void SetValue(int x, int y, int z, int w, T value)
        {
            _map[w, z, y, x] = value;
        }

        public void SetValue(Point4D point, T value)
        {
            SetValue(point.X, point.Y, point.Z, point.W, value);
        }

        public void DistributeChaos(T aliveValue, Func<bool, int, T, T> getNewValue)
        {
            var pointsToChange = new Dictionary<Point4D, T>();

            for (int w = 0; w < SizeW; w++)
            {
                for (int z = 0; z < SizeZ; z++)
                {
                    for (int y = 0; y < SizeY; y++)
                    {
                        for (int x = 0; x < SizeX; x++)
                        {
                            var currentPoint = new Point4D(x, y, z, w);
                            var currentValue = GetValue(currentPoint);
                            var matches = NumberOfNeighborsThatMatch(currentPoint, aliveValue);

                            var newValue = getNewValue(aliveValue.Equals(currentValue), matches, currentValue);
                            if (!newValue.Equals(currentValue))
                            {
                                pointsToChange.Add(currentPoint, newValue);
                            }
                        }
                    }
                }
            }

            foreach (var point in pointsToChange.Keys)
            {
                SetValue(point, pointsToChange[point]);
            }
        }

        public int NumberOfNeighborsThatMatch(Point4D point, T valueToMatch)
        {
            var numberOfMatches = 0;

            for (int w = Math.Max(point.W - 1, 0); w <= point.W + 1 && w < SizeW; w++)
            {
                for (int z = Math.Max(point.Z - 1, 0); z <= point.Z + 1 && z < SizeZ; z++)
                {
                    for (int y = Math.Max(point.Y - 1, 0); y <= point.Y + 1 && y < SizeY; y++)
                    {
                        for (int x = Math.Max(point.X - 1, 0); x <= point.X + 1 && x < SizeX; x++)
                        {
                            if (w == point.W && z == point.Z && y == point.Y && x == point.X)
                            {
                                continue;
                            }

                            if (_map[w, z, y, x].Equals(valueToMatch))
                            {
                                numberOfMatches++;
                            }
                        }
                    }
                }
            }

            return numberOfMatches;
        }

        public int Count(T valueToMatch)
        {
            int count = 0;
            for (int w = 0; w < SizeW; w++)
            {
                for (int z = 0; z < SizeZ; z++)
                {
                    for (int y = 0; y < SizeY; y++)
                    {
                        for (int x = 0; x < SizeX; x++)
                        {
                            if (_map[w, z, y, x].Equals(valueToMatch))
                            {
                                count++;
                            }
                        }
                    }
                }
            }

            return count;
        }
    }
}
