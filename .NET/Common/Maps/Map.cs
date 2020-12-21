using System;
using System.Collections.Generic;
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
    }
}
