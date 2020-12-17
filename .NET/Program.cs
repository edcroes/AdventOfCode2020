using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;

namespace AoC2020
{
    public class Program
    {
        static void Main(string[] args)
        {
            var allDays = GetDays();
            var dayType = allDays.Last();

            if (args != null && args.Length > 0 &&  int.TryParse(args[0], out int day))
            {
                dayType = allDays.SingleOrDefault(d => d.Name.EndsWith(day.ToString("D2"))) ?? dayType;
            }

            var dayInstance = (IMDay)Activator.CreateInstance(dayType);
            var stopwatch = new Stopwatch();

            Console.WriteLine(dayType.Name);
            Console.WriteLine("-----");

            stopwatch.Start();
            Console.WriteLine($"Answer Part 1: {dayInstance.GetAnswerPart1()}");
            var part1TimeTaken = stopwatch.Elapsed;

            stopwatch.Restart();
            Console.WriteLine($"Answer Part 2: {dayInstance.GetAnswerPart2()}");
            var part2TimeTaken = stopwatch.Elapsed;
            stopwatch.Stop();

            Console.WriteLine();
            Console.WriteLine($"Part 1 took: {part1TimeTaken}");
            Console.WriteLine($"Part 2 took: {part2TimeTaken}");

            Console.WriteLine();
            Console.WriteLine("Press any key to exit...");
            Console.ReadLine();
        }

        private static IEnumerable<Type> GetDays()
        {
            return Assembly
                .GetExecutingAssembly()
                .GetTypes()
                .Where(t => t.GetInterfaces().Contains(typeof(IMDay)))
                .OrderBy(t => t.Name);
        }
    }
}
