namespace AoC2020.Common
{
    public class LinkedItem<T>
    {
        public T Value { get; set; }
        public LinkedItem<T> Next { get; set; }
    }
}
