class env extends uvm_env;

  typedef env this_t;
 
  // Register this with the UVM factory.
  `uvm_component_param_utils( this_t );

  // Declare tx_agent to be a handle of type ethernet_agent
  ethernet_agent tx_agent;

  env_config m_config;

  //ICMP Monitors
  ethernet_icmp4_monitor icmp4_mon_m;
  ethernet_icmp6_monitor icmp6_mon_m;

  // Declare tcp_monitor and udp_monitor 
  ethernet_tcp_monitor tcp_mon_m;
  ethernet_udp_monitor udp_mon_m;

  // Declare IPv4/6 Monitors 
  ethernet_ipv4_monitor ipv4_mon_m;

  // Declare tcp_scoreboard and udp_scoreboard 
  ethernet_tcp_checksum_scoreboard tcp_sb_m;

  // Declare ICMP scoreboard
  ethernet_icmp4_checksum_scoreboard icmp4_sb_m;
  ethernet_icmp6_checksum_scoreboard icmp6_sb_m;

  // Declare igmp_ipv4_scoreboard, igmp_ipv6_scoreboard,
  ethernet_igmp4_checksum_scoreboard igmp_ipv4_sb_m;
  ethernet_igmp6_checksum_scoreboard igmp_ipv6_sb_m;

  // Declare sctp_ipv4_scoreboard, sctp_ipv6_scoreboard,
  ethernet_sctp4_checksum_scoreboard sctp_ipv4_sb_m;
  ethernet_sctp6_checksum_scoreboard sctp_ipv6_sb_m;

  ethernet_udp_ipv4_checksum_scoreboard udp_v1_ipv4_sb_m;
  ethernet_udp_checksum_scoreboard      udp_v1_ipv6_sb_m;

  ethernet_udp_ipv4_checksum_scoreboard udp_v2_ipv4_sb_m;
  ethernet_udp_checksum_scoreboard      udp_v2_ipv6_sb_m;

  ethernet_ipv4_checksum_scoreboard     ipv4_sb_m;

  extern function new( string name , uvm_component parent );
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

// -------------------------------------------------------------------
// Function: new
//
// This is a standard new function.

function env::new( string name , uvm_component parent );
  super.new( name , parent );
endfunction

// -------------------------------------------------------------------
// tx_agent is handle to ethernet_agent. In this function
// new ethernet_agent object is created and the handle tx_agent is assigned to 
// respective object. The name "tx_agent" will appear in the UVM hierarchy.
function void env::build_phase(uvm_phase phase);

  tx_agent = ethernet_agent::type_id::create("tx_agent", this);

  // Getting the env_cfg from test.
  if(!uvm_config_db #( env_config )::get( this , "", s_env_config_id ,
                                       m_config ))
    `uvm_error("ENV/ENV_CFG Error" , 
               "uvm_config_db #( env_cfg )::get cannot find resource env_cfg");
  
  tx_agent.cfg = m_config.tx_cfg;

  uvm_config_db #( uvm_object )::set( this , "**"   , mvc_config_base_id , m_config.tx_cfg ); 

  icmp4_mon_m            = ethernet_icmp4_monitor::type_id::create("icmp4_mon_m",this);
  icmp6_mon_m            = ethernet_icmp6_monitor::type_id::create("icmp6_mon_m",this);
 
  tcp_mon_m              = ethernet_tcp_monitor::type_id::create("tcp_mon_m",this);
  udp_mon_m              = ethernet_udp_monitor::type_id::create("udp_mon_m",this);

  ipv4_mon_m             = ethernet_ipv4_monitor::type_id::create("ipv4_mon_m",this);

  // Creating Scoreboards.
  tcp_sb_m         = ethernet_tcp_checksum_scoreboard::type_id::create("tcp_checksum_sb_m", this) ;

  icmp4_sb_m       = ethernet_icmp4_checksum_scoreboard::type_id::create("icmp4_checksum_sb_m", this) ;
  icmp6_sb_m       = ethernet_icmp6_checksum_scoreboard::type_id::create("icmp6_checksum_sb_m", this) ;

  igmp_ipv4_sb_m   = ethernet_igmp4_checksum_scoreboard::type_id::create("igmp4_checksum_sb_m", this) ;
  igmp_ipv6_sb_m   = ethernet_igmp6_checksum_scoreboard::type_id::create("igmp6_checksum_sb_m", this) ;

  sctp_ipv4_sb_m   = ethernet_sctp4_checksum_scoreboard::type_id::create("sctp4_checksum_sb_m", this) ;
  sctp_ipv6_sb_m   = ethernet_sctp6_checksum_scoreboard::type_id::create("sctp6_checksum_sb_m", this) ;

  udp_v1_ipv4_sb_m = ethernet_udp_ipv4_checksum_scoreboard::type_id::create("udp_ipv4_checksum_sb_m", this) ;
  udp_v1_ipv6_sb_m = ethernet_udp_checksum_scoreboard     ::type_id::create("udp_v1_ipv6_sb_m", this) ;

  udp_v2_ipv4_sb_m = ethernet_udp_ipv4_checksum_scoreboard::type_id::create("udp_v2_ipv4_sb_m", this) ;
  udp_v2_ipv6_sb_m = ethernet_udp_checksum_scoreboard     ::type_id::create("udp_v2_ipv6_sb_m", this) ;

  ipv4_sb_m        = ethernet_ipv4_checksum_scoreboard::type_id::create("ipv4_sb_m", this) ;

endfunction

function void env::connect_phase(uvm_phase phase);

  icmp4_mon_m.ap.connect(icmp4_sb_m.m_icmp4_analysis_export);
  icmp6_mon_m.ap.connect(icmp6_sb_m.m_icmp6_analysis_export);

  tcp_mon_m.ap.connect(tcp_sb_m.m_mac_side_tcp_analysis_export);

  ipv4_mon_m.ap.connect(ipv4_sb_m.analysis_export);

endfunction
