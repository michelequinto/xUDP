class env_config extends uvm_object;
 
  typedef env_config env_config_t;

  `uvm_object_param_utils( env_config_t );

  typedef ethernet_vip_config config_t;
  
  config_t tx_cfg;

  extern function new( string name = "" );
  
  // Function: get_config
  //
  // This static method hides the dynamic casting implicit in 
  // the UVM config mechanism. It also prints out useful messages when
  // either there is no uvm_object associated with this id and this 
  // component, or there is an uvm_object but it is not of the correct
  // type.

  static function env_config_t get_config( uvm_component c );
     uvm_object o;
     env_config_t t;

   if(!uvm_config_db #( env_config_t )::get( c,"", s_env_config_id , t ) ) begin
     `uvm_error("Config Error","uvm_config_db #(env_config_t)::get() cannot find resource s_env_config_id");
      return null;
     end

     return t;
  endfunction
endclass

// -------------------------------------------------------------------
// Function: new
//
// This is a standard new function.
// ---------------------------------------------------------------

function env_config::new( string name = "" );
  super.new( name );

  tx_cfg = new();
endfunction
