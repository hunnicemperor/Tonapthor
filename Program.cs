using System;
using System.IO;

class Program
{
    static string buffer = "";
    static string currentFile = "";
    
    static void Main()
    {
        Console.Title = "Tonapthor Editor";
        
        while (true)
        {
            Console.Clear();
            
            // Simple header
            Console.WriteLine("=== TONAPHOR EDITOR ===");
            Console.WriteLine($"File: {(string.IsNullOrEmpty(currentFile) ? "(none)" : currentFile)}");
            Console.WriteLine($"Buffer: {buffer.Split('\n').Length} lines, {buffer.Length} chars");
            Console.WriteLine();
            
            // Menu
            Console.WriteLine("Commands:");
            Console.WriteLine("  write  - Write code");
            Console.WriteLine("  save   - Save to file");
            Console.WriteLine("  show   - Show buffer");
            Console.WriteLine("  list   - List files");
            Console.WriteLine("  clear  - Clear buffer");
            Console.WriteLine("  exit   - Exit");
            Console.WriteLine();
            
            Console.Write("> ");
            string cmd = Console.ReadLine();
            
            switch (cmd.ToLower())
            {
                case "write":
                    WriteCode();
                    break;
                case "save":
                    SaveCode();
                    break;
                case "show":
                    ShowCode();
                    break;
                case "list":
                    ListFiles();
                    break;
                case "clear":
                    buffer = "";
                    currentFile = "";
                    Console.WriteLine("Cleared.");
                    break;
                case "exit":
                    Console.WriteLine("Goodbye!");
                    return;
                default:
                    Console.WriteLine($"Unknown command: {cmd}");
                    break;
            }
            
            if (cmd != "exit")
            {
                Console.WriteLine("\nPress any key...");
                Console.ReadKey();
            }
        }
    }
    
    static void WriteCode()
    {
        Console.Clear();
        Console.WriteLine("WRITE CODE (empty line to finish)");
        Console.WriteLine("==================================");
        Console.WriteLine();
        
        buffer = "";
        int lineNum = 1;
        
        while (true)
        {
            Console.Write($"{lineNum}> ");
            string line = Console.ReadLine();
            
            if (string.IsNullOrWhiteSpace(line))
                break;
                
            buffer += line + "\n";
            lineNum++;
        }
        
        Console.WriteLine($"\n{lineNum-1} lines written.");
    }
    
    static void SaveCode()
    {
        if (string.IsNullOrEmpty(currentFile))
        {
            Console.Write("Save as: ");
            currentFile = Console.ReadLine();
            
            if (string.IsNullOrWhiteSpace(currentFile))
                currentFile = "program.cs";
                
            if (!currentFile.EndsWith(".cs"))
                currentFile += ".cs";
        }
        
        try
        {
            File.WriteAllText(currentFile, buffer);
            Console.WriteLine($"Saved to {currentFile}");
            Console.WriteLine($"{buffer.Split('\n').Length} lines, {buffer.Length} chars");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }
    
    static void ShowCode()
    {
        if (string.IsNullOrEmpty(buffer))
        {
            Console.WriteLine("Buffer is empty");
            return;
        }
        
        Console.WriteLine("\n=== BUFFER ===");
        Console.WriteLine(buffer);
        Console.WriteLine("==============");
    }
    
    static void ListFiles()
    {
        Console.WriteLine("\n=== FILES ===");
        
        var files = Directory.GetFiles(".", "*.cs");
        
        if (files.Length == 0)
        {
            Console.WriteLine("No .cs files found");
        }
        else
        {
            foreach (var file in files)
            {
                var info = new FileInfo(file);
                Console.WriteLine($"  {info.Name} - {info.Length} bytes");
            }
        }
        
        Console.WriteLine("=============");
    }
}
