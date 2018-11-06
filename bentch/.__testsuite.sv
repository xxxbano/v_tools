module __testsuite;
  import svunit_pkg::svunit_testsuite;

  string name = "__ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  Flag_CrossDomain_unit_test Flag_CrossDomain_ut();


  //===================================
  // Build
  //===================================
  function void build();
    Flag_CrossDomain_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(Flag_CrossDomain_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    Flag_CrossDomain_ut.run();
    svunit_ts.report();
  endtask

endmodule
