module __testsuite;
  import svunit_pkg::svunit_testsuite;

  string name = "__ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  fifo_unit_test fifo_ut();
  lifo_unit_test lifo_ut();


  //===================================
  // Build
  //===================================
  function void build();
    fifo_ut.build();
    lifo_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(fifo_ut.svunit_ut);
    svunit_ts.add_testcase(lifo_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    fifo_ut.run();
    lifo_ut.run();
    svunit_ts.report();
  endtask

endmodule
