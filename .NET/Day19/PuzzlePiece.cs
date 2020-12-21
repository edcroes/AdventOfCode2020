using AoC2020.Common;
using AoC2020.Common.Maps;

namespace AoC2020.Day19
{
    public class PuzzlePiece
    {
        private short[] _borderIds;
        private short[] _flippedBorderIds;

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

                    _borderIds = new[] {
                        top.ConvertToShort(),
                        right.ConvertToShort(),
                        bottom.ConvertToShort(),
                        left.ConvertToShort()
                    };
                }

                return _borderIds;
            }
        }

        public short[] FlippedBorderIds
        {
            get
            {
                if (_flippedBorderIds == null)
                {
                    var top = Picture.GetLine(Picture.SizeX - 1, 0, 0, 0);
                    var right = Picture.GetLine(Picture.SizeX - 1, Picture.SizeY - 1, Picture.SizeX - 1, 0);
                    var bottom = Picture.GetLine(Picture.SizeX - 1, Picture.SizeY - 1, 0, Picture.SizeY - 1);
                    var left = Picture.GetLine(0, Picture.SizeY - 1, 0, 0);

                    _flippedBorderIds = new[] {
                        top.ConvertToShort(),
                        right.ConvertToShort(),
                        bottom.ConvertToShort(),
                        left.ConvertToShort()
                    };
                }

                return _flippedBorderIds;
            }
        }

        public short TopBorderId => BorderIds[0];
        public short RightBorderId => BorderIds[1];
        public short BottomBorderId => BorderIds[2];
        public short LeftBorderId => BorderIds[3];

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
