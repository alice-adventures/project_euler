-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Text_IO;               use Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with AnsiAda;        use AnsiAda;
with Parse_Args;     use Parse_Args;
with Simple_Logging; use Simple_Logging;

with Project_Euler_Config; use Project_Euler_Config;
with Project_Euler.CLI.Problems;

package body Project_Euler.CLI is

   package Log renames Simple_Logging;

   Indent    : constant String  := "   ";
   Par_Width : constant Natural := 80;
   Use_Ansi  : constant Boolean := True;

   function Fill_Paragraph (Text : String) return String is
      Head, Tail : Unbounded_String;
      Cut        : Natural;
   begin
      if Text'Length > Par_Width then
         Head := Null_Unbounded_String;
         Tail := To_Unbounded_String (Text);
         loop
            Cut := Par_Width;
            loop
               exit when Tail.Element (Cut) = ' ';
               Cut := Cut - 1;
            end loop;
            Head := Head & Tail.Unbounded_Slice (1, Cut - 1) & ASCII.LF;
            Tail := Indent & Tail.Unbounded_Slice (Cut + 1, Tail.Length);
            exit when Tail.Length <= Par_Width;
         end loop;
         return To_String (Head & Tail);
      end if;
      return Text;
   end Fill_Paragraph;

   procedure Run (Problem : in out Problems.Problem_Interface'Class) is
   begin
      pragma Warnings (Off);
      if Project_Euler_Config.Build_Profile = development then
         Log.Level := Log.Debug;
      else
         Log.Level := Log.Info;
      end if;
      pragma Warnings (On);

      Argument_Parser.Add_Option
        (Make_Boolean_Option (False), "help", 'h', "help",
         "Display this text");
      Problem.Configure_Options;

      Argument_Parser.Parse_Command_Line;
      if Argument_Parser.Parse_Success then
         if Argument_Parser.Boolean_Value ("help") then
            Argument_Parser.Usage;
            return;
         else
            Problem.Parse_Options;
         end if;
      else
         Put_Line
           ("Error while parsing command-line arguments: " &
            Argument_Parser.Parse_Message);
         return;
      end if;

      if Use_Ansi then
         Put_Line
           (Color_Wrap
              (Text       =>
                 " Problem" & Problem.Number'Image & " - " & Problem.Title &
                 " ",
               Foreground => Foreground (Black),
               Background => Background (Light_Grey)));
      else
         Put_Line ("Problem" & Problem.Number'Image & " - " & Problem.Title);
      end if;

      Put (Indent);
      if Use_Ansi then
         Put_Line (Style_Wrap (Fill_Paragraph (Problem.Brief), Italic));
      else
         Put_Line (Fill_Paragraph (Problem.Brief));
      end if;

      declare
         Known_Solution   : Boolean          := False;
         Notes            : Unbounded_String := Null_Unbounded_String;
         Answer           : constant String  := Problem.Answer (Notes);
         Correct_Solution : constant Boolean :=
           Project_Euler.Check_Solution
             (Problem.Number, Answer, Known_Solution);
      begin
         Put (Indent & "Answer: " & Answer);
         Put ("  [ ");
         if Known_Solution then
            if Correct_Solution then
               Put
                 (Color_Wrap (Text => "Ok", Foreground => Foreground (Green)));
            else
               Put
                 (Color_Wrap (Text => "FAIL", Foreground => Foreground (Red)));
            end if;
         else
            Put
              (Color_Wrap (Text => "TBD", Foreground => Foreground (Yellow)));
         end if;
         Put (" ]");
         New_Line;

         if Notes.Length > 0 then
            Put (Indent);
            Put_Line (Fill_Paragraph ("Note: " & To_String (Notes)));
         end if;

         New_Line;
      end;
   end Run;

end Project_Euler.CLI;
