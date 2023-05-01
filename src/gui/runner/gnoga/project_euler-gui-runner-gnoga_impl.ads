-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Project_Euler.GUI.Runner;  use Project_Euler.GUI.Runner;
with Project_Euler.GUI.Problem; use Project_Euler.GUI.Problem;

with Gnoga.Types;

package Project_Euler.GUI.Runner.Gnoga_Impl is

   type Gnoga_Runner_Type is new GUI_Runner_Type with null record;

   type Runner_Control_Callback is
     access procedure
       (App_Data : not null Gnoga.Types.Pointer_to_Connection_Data_Class);

   type Runner_Answer_Callback is
     access procedure
       (App_Data : not null Gnoga.Types.Pointer_to_Connection_Data_Class;
        Answer   : String);

   overriding procedure Run
     (Runner          : Gnoga_Runner_Type;
      Problem_Factory : Pointer_To_Problem_Factory_Function);

end Project_Euler.GUI.Runner.Gnoga_Impl;
