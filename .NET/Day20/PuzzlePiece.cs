using AoC2020.Common;
using AoC2020.Common.Maps;

namespace AoC2020.Day20
{
    public class PuzzlePiece
    {
        public enum Border
        {
            None = -1,
            Top = 0,
            Right = 1,
            Bottom = 2,
            Left = 3,
            FlippedTop = 4,
            FlippedRight = 5,
            FlippedBottom = 6,
            FlippedLeft = 7
        }

        private short[] _borderIds;

        public int Id { get; }
        public Map<bool> Picture { get; }

        private PuzzlePiece(int id, Map<bool> picture)
        {
            Id = id;
            Picture = picture;
        }

        public short[] BorderIds
        {
            get
            {
                if (_borderIds == null)
                {
                    var top = Picture.GetLine(0, 0, Picture.SizeX - 1, 0);
                    var right = Picture.GetLine(Picture.SizeX - 1, 0, Picture.SizeX - 1, Picture.SizeY - 1);
                    var bottom = Picture.GetLine(0, Picture.SizeY - 1, Picture.SizeX - 1, Picture.SizeY - 1);
                    var left = Picture.GetLine(0, 0, 0, Picture.SizeY - 1);
                    var flippedTop = Picture.GetLine(Picture.SizeX - 1, 0, 0, 0);
                    var flippedRight = Picture.GetLine(Picture.SizeX - 1, Picture.SizeY - 1, Picture.SizeX - 1, 0);
                    var flippedBottom = Picture.GetLine(Picture.SizeX - 1, Picture.SizeY - 1, 0, Picture.SizeY - 1);
                    var flippedLeft = Picture.GetLine(0, Picture.SizeY - 1, 0, 0);

                    _borderIds = new[] {
                        top.ConvertToShort(),
                        right.ConvertToShort(),
                        bottom.ConvertToShort(),
                        left.ConvertToShort(),
                        flippedTop.ConvertToShort(),
                        flippedRight.ConvertToShort(),
                        flippedBottom.ConvertToShort(),
                        flippedLeft.ConvertToShort()
                    };
                }

                return _borderIds;
            }
        }

        public short TopBorderId => BorderIds[(int)Border.Top];
        public short RightBorderId => BorderIds[(int)Border.Right];
        public short BottomBorderId => BorderIds[(int)Border.Bottom];
        public short LeftBorderId => BorderIds[(int)Border.Left];
        public short FlippedTopBorderId => BorderIds[(int)Border.FlippedTop];
        public short FlippedRightBorderId => BorderIds[(int)Border.FlippedRight];
        public short FlippedBottomBorderId => BorderIds[(int)Border.FlippedBottom];
        public short FlippedLeftBorderId => BorderIds[(int)Border.FlippedLeft];

        public short GetBorderId(Border border)
        {
            return BorderIds[(int)border];
        }

        public void RotateRight()
        {
            Picture.RotateRight();
            _borderIds = null;
        }

        public void MirrorHorizontal()
        {
            Picture.MirrorHorizontal();
            _borderIds = null;
        }

        public void MirrorVertical()
        {
            Picture.MirrorVertical();
            _borderIds = null;
        }

        public static PuzzlePiece ParsePiece(string part)
        {
            var lines = part.Replace("\r", "").Split("\n");
            var id = int.Parse(lines[0][5..].Trim().TrimEnd(':'));
            var picture = new Map<bool>(lines[1].Length, lines.Length - 1);

            for (int y = 0; y < lines.Length - 1; y++)
            {
                var chars = lines[y + 1].ToCharArray();
                for (int x = 0; x < lines[1].Length; x++)
                {
                    picture.SetValue(x, y, chars[x] == '#');
                }
            }

            return new PuzzlePiece(id, picture);
        }
    }
}
