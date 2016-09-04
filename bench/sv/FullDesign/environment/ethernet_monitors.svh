class ethernet_pkt_mon #(type seq_item_type = int , string ap_name = "")  extends uvm_component;

  typedef ethernet_pkt_mon #( seq_item_type, ap_name ) this_t;

  `uvm_component_param_utils( this_t )

  typedef seq_item_type mvc_seq_item_type;
  
  mvc_seq_item_type t;
 
  typedef ethernet_vip_config config_t;

  // 
  // PORT: ap
  //
  // This is the analysis port
  //
  uvm_analysis_port #( mvc_sequence_item_base ) ap;
  
  // 
  // Variable :  m_config
  //
  // It is the handle of ethernet_vip_config.
  //
  // It has access to all config variables in QVIP.
  //
  config_t m_config;
  // 
  // Function: new
  //
  // The standard uvm constructor.
  //
  extern function new(string name, uvm_component parent );

  //
  // Function: build
  //
  // Build creates the analysis port.
  //
  extern function void build_phase(uvm_phase phase);

  //
  // Task: run
  //
  // It calls the  receive task
  //
  extern task run_phase(uvm_phase phase);

endclass

function ethernet_pkt_mon::new(string name, uvm_component parent );
  super.new(name, parent);
endfunction

function void ethernet_pkt_mon::build_phase ( uvm_phase phase);
  super.build_phase(phase);
  m_config = config_t::get_config(this);
  ap = new( "ap_name" , this );
endfunction

task ethernet_pkt_mon::run_phase(uvm_phase phase);
  int m_stream_id;
  super.run_phase(phase);
  m_stream_id = get_stream_id(this);

  if( ap == null )
    `uvm_error ("NULL_POINTER", "The analysis port has a value of null");
        
  forever begin
    t = seq_item_type::type_id::create("packet",this);
    t.m_receive_id = m_stream_id;
    t.receive( m_config );
    ap.write( t );
  end
endtask

typedef ethernet_pkt_mon #(ethernet_ptp_v1_udp_ipv6_packet, "ptp_packet_ap")       ethernet_ptp_v1_udp_ipv6_monitor;
typedef ethernet_pkt_mon #(ethernet_ptp_v1_udp_ipv4_packet, "ptp_packet_ap")       ethernet_ptp_v1_udp_ipv4_monitor;
typedef ethernet_pkt_mon #(ethernet_ptp_v2_eth_packet,      "ptp_packet_ap")       ethernet_ptp_v2_eth_monitor;
typedef ethernet_pkt_mon #(ethernet_ptp_v2_udp_ipv4_packet, "ptp_packet_ap")       ethernet_ptp_v2_udp_ipv4_monitor;
typedef ethernet_pkt_mon #(ethernet_ptp_v2_udp_ipv6_packet, "ptp_packet_ap")       ethernet_ptp_v2_udp_ipv6_monitor;
typedef ethernet_pkt_mon #(ethernet_ptp_v1_eth_packet,      "ptp_packet_ap")       ethernet_ptp_v1_eth_monitor;
typedef ethernet_pkt_mon #(ethernet_device_arp_rarp_frame,  "ARP_RARP_packet_ap")  ethernet_arp_rarp_monitor;
typedef ethernet_pkt_mon #(ethernet_igmp_ipv4_packet,       "IGMP_IPv4_packet_ap") ethernet_igmp_ipv4_monitor;
typedef ethernet_pkt_mon #(ethernet_igmp_ipv6_packet,       "IGMP_IPv6_packet_ap") ethernet_igmp_ipv6_monitor;
typedef ethernet_pkt_mon #(ethernet_ah_ipv4_packet,         "AH_IPv4_packet_ap")   ethernet_ah_ipv4_monitor;
typedef ethernet_pkt_mon #(ethernet_ah_ipv6_packet,         "AH_IPv6_packet_ap")   ethernet_ah_ipv6_monitor;
typedef ethernet_pkt_mon #(ethernet_esp_ipv4_packet,        "ESP_IPv4_packet_ap")  ethernet_esp_ipv4_monitor;
typedef ethernet_pkt_mon #(ethernet_esp_ipv6_packet,        "ESP_IPv6_packet_ap")  ethernet_esp_ipv6_monitor;
typedef ethernet_pkt_mon #(ethernet_stp_rstp_bpdu_packet,   "STP_RSTP_packet_ap")  ethernet_stp_rstp_monitor;
typedef ethernet_pkt_mon #(ethernet_sctp_ipv4_packet,       "sctp_IPv4_packet_ap") ethernet_sctp_ipv4_monitor;
typedef ethernet_pkt_mon #(ethernet_sctp_ipv6_packet,       "sctp_IPv6_packet_ap") ethernet_sctp_ipv6_monitor;
typedef ethernet_pkt_mon #(ethernet_icmp4_packet,           "ICMP4_packet_ap")     ethernet_icmp4_monitor;
typedef ethernet_pkt_mon #(ethernet_icmp6_packet,           "ICMP6_packet_ap")     ethernet_icmp6_monitor;
typedef ethernet_pkt_mon #(ethernet_llc_snap_packet,        "llc_snap_packet_ap")  ethernet_llc_snap_monitor;
typedef ethernet_pkt_mon #(ethernet_tcp_packet,             "TCP_packet_ap")       ethernet_tcp_monitor;
typedef ethernet_pkt_mon #(ethernet_udp_packet,             "UDP_packet_ap")       ethernet_udp_monitor;
typedef ethernet_pkt_mon #(ethernet_ipv4_packet,            "IPv4_Packet_ap")      ethernet_ipv4_monitor;
typedef ethernet_pkt_mon #(ethernet_ipv6_packet,            "IPv6_Packet_ap")      ethernet_ipv6_monitor;

