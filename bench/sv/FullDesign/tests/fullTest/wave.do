onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Top Transactions} {/top/xaui/idle[0]}
add wave -noupdate -expand -group {Top Transactions} {/top/xaui/fault_sequence[0]}
add wave -noupdate -expand -group {Top Transactions} {/top/xaui/data_frame[0]}
add wave -noupdate -expand -group {Top Transactions} {/top/xaui/control_frame[0]}
add wave -noupdate -expand -group {Top Transactions} {/top/xaui/idle[1]}
add wave -noupdate -expand -group {Top Transactions} {/top/xaui/fault_sequence[1]}
add wave -noupdate -expand -group {Top Transactions} {/top/xaui/data_frame[1]}
add wave -noupdate -expand -group {Top Transactions} {/top/xaui/control_frame[1]}
add wave -noupdate -expand -group {Sub Transactions} /top/xaui/ipv4_frame
add wave -noupdate -expand -group {Sub Transactions} {/top/xaui/start_preamble_phase[0]}
add wave -noupdate -expand -group {Sub Transactions} {/top/xaui/preamble_sfd_phase_10g[0]}
add wave -noupdate -expand -group {Sub Transactions} {/top/xaui/start_preamble_phase[1]}
add wave -noupdate -expand -group {Sub Transactions} {/top/xaui/preamble_sfd_phase_10g[1]}
add wave -noupdate -group xaui /top/xaui/iclk_0
add wave -noupdate -group xaui /top/xaui/iclk_1
add wave -noupdate -group xaui /top/xaui/ian_clk_0
add wave -noupdate -group xaui /top/xaui/ian_clk_1
add wave -noupdate -group xaui /top/xaui/iMDC
add wave -noupdate -group xaui /top/xaui/ireset
add wave -noupdate -group xaui /top/xaui/clk_0
add wave -noupdate -group xaui /top/xaui/clk_1
add wave -noupdate -group xaui /top/xaui/an_clk_0
add wave -noupdate -group xaui /top/xaui/an_clk_1
add wave -noupdate -group xaui /top/xaui/MDC
add wave -noupdate -group xaui /top/xaui/reset
add wave -noupdate -group xaui /top/xaui/XD
add wave -noupdate -group xaui /top/xaui/XC
add wave -noupdate -group xaui /top/xaui/lane_bit
add wave -noupdate -group xaui /top/xaui/lane_bit_n
add wave -noupdate -group xaui /top/xaui/L_10b
add wave -noupdate -group xaui /top/xaui/XSBI_DATA_PARALLEL
add wave -noupdate -group xaui /top/xaui/pcs_baser_66b
add wave -noupdate -group xaui /top/xaui/MDIO_OUT
add wave -noupdate -group xaui /top/xaui/MDIO_IN
add wave -noupdate -group xaui /top/xaui/config_enable_clock_recovery
add wave -noupdate -group xaui /top/xaui/config_enable_differential_signaling
add wave -noupdate -group xaui /top/xaui/config_magic_packet_enable
add wave -noupdate -group xaui /top/xaui/config_enable_vlan_double_tagged_frame
add wave -noupdate -group xaui /top/xaui/config_pfc_enable
add wave -noupdate -group xaui /top/xaui/config_priority_pfc_enable
add wave -noupdate -group xaui /top/xaui/config_enable_xgmii_sdr_64
add wave -noupdate -group xaui /top/xaui/config_mac_pause_transmission
add wave -noupdate -group xaui /top/xaui/config_ignore_differential_signaling_cdr
add wave -noupdate -group xaui /top/xaui/config_mac_set_min_tagged_frame_size_68
add wave -noupdate -group xaui /top/xaui/config_mac_fault_state_machine_enable
add wave -noupdate -group xaui /top/xaui/config_mac_jumbo_frame_octet_receive_limit
add wave -noupdate -group xaui /top/xaui/config_mac_data_frame_octet_receive_limit
add wave -noupdate -group xaui /top/xaui/config_mac_type_frame_octet_receive_limit
add wave -noupdate -group xaui /top/xaui/config_mac_ifs_stretch_ratio
add wave -noupdate -group xaui /top/xaui/config_mac_ifs_stretch_mode_enabled
add wave -noupdate -group xaui /top/xaui/config_mask_trace_log
add wave -noupdate -group xaui /top/xaui/config_enable_status_reg_cov
add wave -noupdate -group xaui /top/xaui/config_skip_xmit
add wave -noupdate -group xaui /top/xaui/config_interface_type
add wave -noupdate -group xaui /top/xaui/config_pma_lane_count
add wave -noupdate -group xaui /top/xaui/config_pma_lane_width
add wave -noupdate -group xaui /top/xaui/config_include_fec_layer
add wave -noupdate -group xaui /top/xaui/config_include_rs_fec_layer
add wave -noupdate -group xaui /top/xaui/config_fec_lane_width
add wave -noupdate -group xaui /top/xaui/config_enable_all_assertions
add wave -noupdate -group xaui /top/xaui/config_enable_assertion
add wave -noupdate -group xaui /top/xaui/config_basex_bypass_rx_synchronization
add wave -noupdate -group xaui /top/xaui/config_basex_disparity_error_on_lane
add wave -noupdate -group xaui /top/xaui/config_basex_invalid_symbol_on_lane
add wave -noupdate -group xaui /top/xaui/config_basex_invalid_symbol_after_terminate_os
add wave -noupdate -group xaui /top/xaui/config_basex_invalid_symbol_on_lane_during_frame
add wave -noupdate -group xaui /top/xaui/config_basex_only_R_on_lane_during_idle
add wave -noupdate -group xaui /top/xaui/config_basex_A_on_lane_when_expected_K
add wave -noupdate -group xaui /top/xaui/config_basex_K_on_lane_when_expected_A
add wave -noupdate -group xaui /top/xaui/config_basex_valid_data_on_lane_when_expected_K
add wave -noupdate -group xaui /top/xaui/config_basex_valid_data_on_lane_when_expected_A
add wave -noupdate -group xaui /top/xaui/config_basex_valid_cg_on_lane_when_expected_Q
add wave -noupdate -group xaui /top/xaui/config_basex_valid_cg_on_lane_when_expected_R
add wave -noupdate -group xaui /top/xaui/config_rxaui_aa_error_count
add wave -noupdate -group xaui /top/xaui/config_baser_bypass_scrambler
add wave -noupdate -group xaui /top/xaui/config_baser_invalid_sync_header
add wave -noupdate -group xaui /top/xaui/config_baser_invalid_control_code
add wave -noupdate -group xaui /top/xaui/config_baser_invalid_null_field
add wave -noupdate -group xaui /top/xaui/config_baser_invalid_o_code
add wave -noupdate -group xaui /top/xaui/config_baser_invalid_block_type_field
add wave -noupdate -group xaui /top/xaui/config_baser_invalid_symbol_val
add wave -noupdate -group xaui /top/xaui/config_baser_am_lock_true_on_first_am
add wave -noupdate -group xaui /top/xaui/config_rs_fec_lock_on_first_amp
add wave -noupdate -group xaui /top/xaui/config_baser_corrupt_am
add wave -noupdate -group xaui /top/xaui/config_rs_fec_corrupt_amp
add wave -noupdate -group xaui /top/xaui/config_rs_fec_corrupt_amp_pad
add wave -noupdate -group xaui /top/xaui/config_baser_invalid_66bit_data
add wave -noupdate -group xaui /top/xaui/config_baser_invalid_lane_ptr
add wave -noupdate -group xaui /top/xaui/config_40_100g_baser_invalid_66bit_data
add wave -noupdate -group xaui /top/xaui/config_40_100g_baser_invalid_16bit_bip
add wave -noupdate -group xaui /top/xaui/config_fec_bypass_scrambler
add wave -noupdate -group xaui /top/xaui/config_error_fec_invalid_parity
add wave -noupdate -group xaui /top/xaui/config_rs_fec_invalid_parity
add wave -noupdate -group xaui /top/xaui/config_fec_good_parity_count_n
add wave -noupdate -group xaui /top/xaui/config_fec_invalid_parity_count_m
add wave -noupdate -group xaui /top/xaui/config_wis_G1_octet
add wave -noupdate -group xaui /top/xaui/config_wis_K2_octet
add wave -noupdate -group xaui /top/xaui/config_wis_M1_octet
add wave -noupdate -group xaui /top/xaui/config_wis_bypass_scrambler
add wave -noupdate -group xaui /top/xaui/config_mac_allow_user_preamble
add wave -noupdate -group xaui /top/xaui/config_mac_insert_user_fcs
add wave -noupdate -group xaui /top/xaui/config_mac_include_user_preamble_in_fcs
add wave -noupdate -group xaui /top/xaui/config_mac_pad_octet
add wave -noupdate -group xaui /top/xaui/config_enable_unicast_addr_detection_for_pause_frames
add wave -noupdate -group xaui /top/xaui/config_mmd_default_read_data
add wave -noupdate -group xaui /top/xaui/config_mac_corrupted_fcs_error
add wave -noupdate -group xaui /top/xaui/config_mac_frame_too_long_error
add wave -noupdate -group xaui /top/xaui/config_mac_no_sfd
add wave -noupdate -group xaui /top/xaui/config_mac_skip_fcs_field_error
add wave -noupdate -group xaui /top/xaui/config_mac_undersize_frame_error
add wave -noupdate -group xaui /top/xaui/config_mac_invalid_tcc_error
add wave -noupdate -group xaui /top/xaui/config_mac_invalid_column_error
add wave -noupdate -group xaui /top/xaui/config_mac_column_control_val
add wave -noupdate -group xaui /top/xaui/config_mac_corrupted_len_field_error
add wave -noupdate -group xaui /top/xaui/config_mac_enable_control_len_type_error
add wave -noupdate -group xaui /top/xaui/config_allow_multiple_errors_in_frame
add wave -noupdate -group xaui /top/xaui/config_eee_enable
add wave -noupdate -group xaui /top/xaui/config_wake_up_time
add wave -noupdate -group xaui /top/xaui/config_lpi_clk_stop_enable
add wave -noupdate -group xaui /top/xaui/config_lpi_clk_resume
add wave -noupdate -group xaui /top/xaui/config_no_of_clk_before_stop
add wave -noupdate -group xaui /top/xaui/config_no_of_clk_before_stop_device1
add wave -noupdate -group xaui /top/xaui/config_no_of_clk_before_exit_lpi
add wave -noupdate -group xaui /top/xaui/config_reset_high_clocks
add wave -noupdate -group xaui /top/xaui/config_reset_hold_time
add wave -noupdate -group xaui /top/xaui/config_tx_clk_init_value
add wave -noupdate -group xaui /top/xaui/config_rx_clk_init_value
add wave -noupdate -group xaui /top/xaui/config_tx_clk_phase_shift
add wave -noupdate -group xaui /top/xaui/config_rx_clk_phase_shift
add wave -noupdate -group xaui /top/xaui/config_mdio_clk_init_value
add wave -noupdate -group xaui /top/xaui/config_mdio_clk_phase_shift
add wave -noupdate -group xaui /top/xaui/config_mdio_setup_time
add wave -noupdate -group xaui /top/xaui/config_mdio_hold_time
add wave -noupdate -group xaui /top/xaui/config_autoneg_enable
add wave -noupdate -group xaui /top/xaui/config_an_tx_clk_init_value
add wave -noupdate -group xaui /top/xaui/config_an_rx_clk_init_value
add wave -noupdate -group xaui /top/xaui/config_an_tx_clk_phase_shift
add wave -noupdate -group xaui /top/xaui/config_an_rx_clk_phase_shift
add wave -noupdate -group xaui /top/xaui/config_delimiter_transitions_min
add wave -noupdate -group xaui /top/xaui/config_delimiter_transitions
add wave -noupdate -group xaui /top/xaui/config_delimiter_transitions_max
add wave -noupdate -group xaui /top/xaui/config_clock_transitions_min
add wave -noupdate -group xaui /top/xaui/config_clock_transitions
add wave -noupdate -group xaui /top/xaui/config_clock_transitions_max
add wave -noupdate -group xaui /top/xaui/config_data_transitions_min
add wave -noupdate -group xaui /top/xaui/config_data_transitions
add wave -noupdate -group xaui /top/xaui/config_data_transitions_max
add wave -noupdate -group xaui /top/xaui/config_page_max_timer
add wave -noupdate -group xaui /top/xaui/config_an_selector_field
add wave -noupdate -group xaui /top/xaui/config_an_pause_capability
add wave -noupdate -group xaui /top/xaui/config_an_ability
add wave -noupdate -group xaui /top/xaui/config_an_fec
add wave -noupdate -group xaui /top/xaui/config_mr_adv_ability
add wave -noupdate -group xaui /top/xaui/config_break_link_timer
add wave -noupdate -group xaui /top/xaui/config_np_tx
add wave -noupdate -group xaui /top/xaui/config_number_np
add wave -noupdate -group xaui /top/xaui/config_an_allow_user_page
add wave -noupdate -group xaui /top/xaui/config_an_user_transmitted_nonce
add wave -noupdate -group xaui /top/xaui/config_an_user_page
add wave -noupdate -group xaui /top/xaui/config_restart_autoneg
add wave -noupdate -group xaui /top/xaui/config_enable_higig2
add wave -noupdate -group xaui /top/xaui/config_higig_inter_msg_octets_gap
add wave -noupdate -group xaui /top/xaui/config_enable_higig_preemptive_transmission
add wave -noupdate -group xaui /top/xaui/status_mac_error_in_preamble
add wave -noupdate -group xaui /top/xaui/status_mac_error_in_frame
add wave -noupdate -group xaui /top/xaui/status_mac_frame_too_long
add wave -noupdate -group xaui /top/xaui/status_mac_undersize_frame
add wave -noupdate -group xaui /top/xaui/status_mac_frame_length_mismatch
add wave -noupdate -group xaui /top/xaui/status_mac_frame_fcs_error
add wave -noupdate -group xaui /top/xaui/status_mac_fcs_value
add wave -noupdate -group xaui /top/xaui/status_higig_msg_fcs_value
add wave -noupdate -group xaui /top/xaui/status_mac_invalid_frame_terminated
add wave -noupdate -group xaui /top/xaui/status_start_of_frame
add wave -noupdate -group xaui /top/xaui/status_mac_frame_with_less_ifg
add wave -noupdate -group xaui /top/xaui/status_eee_clk_stopped
add wave -noupdate -group xaui /top/xaui/status_magic_packet_detected
add wave -noupdate -group xaui /top/xaui/status_mdio_port_address
add wave -noupdate -group xaui /top/xaui/status_mdio_device_address
add wave -noupdate -group xaui /top/xaui/status_mdio_ext_reg_address
add wave -noupdate -group xaui /top/xaui/status_configure_mmd_read_data
add wave -noupdate -group xaui /top/xaui/status_10g_baser_block_lock
add wave -noupdate -group xaui /top/xaui/status_10g_baser_slip_done
add wave -noupdate -group xaui /top/xaui/status_initialization_done
add wave -noupdate -group xaui /top/xaui/status_baser_block_lock
add wave -noupdate -group xaui /top/xaui/status_baser_am_lock
add wave -noupdate -group xaui /top/xaui/m_clk_factor_ps
add wave -noupdate -group xaui /top/xaui/config_baser_end_wlm_connected
add wave -noupdate -group xaui /top/xaui/config_basex_bypass_rx_alignement
add wave -noupdate -group xaui /top/xaui/config_higig_number_of_messsage_allowed
add wave -noupdate -group xaui /top/xaui/initial_config_done
add wave -noupdate -group xaui /top/xaui/ethernet_device_end
add wave -noupdate -group xaui /top/xaui/ethernet_clk_contr_end
add wave -noupdate -group xaui /top/xaui/ethernet_rst_contr_end
add wave -noupdate -group xaui /top/xaui/ethernet_mdio_clk_contr_end
add wave -noupdate -group xaui /top/xaui/ethernet_sta_end
add wave -noupdate -group xaui /top/xaui/ethernet_mmd_end
add wave -noupdate -group xaui /top/xaui/ethernet_an_clk_contr_end
add wave -noupdate -group xaui /top/xaui/ethernet__monitor_end
add wave -noupdate -group xaui /top/xaui/_interface_ref
add wave -noupdate -group xaui /top/xaui/m_clk_0
add wave -noupdate -group xaui /top/xaui/m_clk_1
add wave -noupdate -group xaui /top/xaui/m_an_clk_0
add wave -noupdate -group xaui /top/xaui/m_an_clk_1
add wave -noupdate -group xaui /top/xaui/m_MDC
add wave -noupdate -group xaui /top/xaui/m_reset
add wave -noupdate -group xaui /top/xaui/m_MDIO_OUT
add wave -noupdate -group xaui /top/xaui/m_MDIO_IN
add wave -noupdate -expand -group xgmii /top/xudp/xgmii_txd
add wave -noupdate -expand -group xgmii /top/xudp/xgmii_txc
add wave -noupdate -expand -group xgmii /top/xudp/xgmii_rxd
add wave -noupdate -expand -group xgmii /top/xudp/xgmii_rxc
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/dclk
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/clk156
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/refclk
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/reset
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/reset156
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/txoutclk
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/xgmii_txd
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/xgmii_txc
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/xgmii_rxd
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/xgmii_rxc
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/txlock
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/signal_detect
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/align_status
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/sync_status
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/drp_addr
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/drp_en
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/drp_i
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/drp_o
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/drp_rdy
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/drp_we
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_tx_ready
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/configuration_vector
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/status_vector
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/GT_TXOUTCLK
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_txdata
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_txcharisk
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdata
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_enable_align
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_enchansync
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_syncok
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_reset_terms
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codevalid
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxchariscomma
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdata_reg
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg0
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg1
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg2
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg3
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg4
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg5
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg6
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg7
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcharisk_reg
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxlock_reg
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxlock_r1
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable_reg0
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable_reg1
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable_reg2
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable_reg3
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable_reg4
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable_reg5
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable_reg6
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxnotintable_reg7
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr_reg0
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr_reg1
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr_reg2
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr_reg3
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr_reg4
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr_reg5
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr_reg6
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxdisperr_reg7
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg0
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg1
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg2
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg3
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg4
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg5
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg6
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg7
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_codecomma_reg
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxcdr_reset
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rx_reset
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxlock
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_tx_fault
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_loopback
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_powerdown
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_powerdown_2
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_powerdown_r
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_powerdown_falling
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_plllocked
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxresetdone
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxbuferr
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxbufstatus
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxbufstatus_reg
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxlossofsync
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_txresetdone
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/loopback_int
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/lock
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/cbm_rx_reset
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/reset_txsync
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/gtx0_rxchbondo_i
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/gtx1_rxchbondo_i
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/gtx2_rxchbondo_i
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/gtx3_rxchbondo_i
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_rxchanisaligned
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/comma_align_done
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/chanbond_done
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/sync_status_i
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/align_status_i
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_txenpmaphasealign
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_txpmasetphase
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_txdlyaligndisable
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_txdlyalignreset
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/mgt_txreset
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/resetdone
add wave -noupdate -group xaui_inst /top/xudp/XAUI_MANAGMENT_BLOCK/xaui_inst/tx_sync_done
add wave -noupdate -expand -group xge_mac_inst /top/xudp/axi_tx
add wave -noupdate -expand -group xge_mac_inst /top/xudp/axi_tx_tready
add wave -noupdate -expand -group xge_mac_inst /top/xudp/axi_rx
add wave -noupdate -expand -group xge_mac_inst /top/xudp/axi_rx_tready
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_rx_sop
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_rx_val
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_rx_mod
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_rx_err
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_rx_eop
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_rx_data
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_rx_avail
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/axi_rx_tvalid_i
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/frame_started
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_tx_full
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_tx_val
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_tx_sop
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_tx_mod
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_tx_eop
add wave -noupdate -expand -group xge_mac_inst /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/pkt_tx_data
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/ip_tx_start
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/ip_tx
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/ip_tx_result
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/ip_rx_start
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/ip_rx
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/control
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/arp_pkt_count
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/ip_pkt_count
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/mac_tx
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/mac_rx
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/arp_req_req_int
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/arp_req_rslt_int
add wave -noupdate -group ip_inst /top/xudp/IP/ip_inst/ip_mac_req
add wave -noupdate /top/xudp/IP/ip_inst/ip_mac_grant
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/ip_rx
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/ip_rx_start
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/clk
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/rst
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/our_ip_address
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/rx_pkt_count
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/mac_rx
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/rx_state
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/next_rx_state
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/wordCntCount
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/wordCntRst
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/wordCntData
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/frameCntCount
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/frameCntData
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/errCntCount
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/errCntData
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/set_src_ip
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/set_dest_ip_l
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/set_dest_ip_h
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/set_protocol
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/dest_ip_addr_i
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/rx_err_i
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/tkeep_i
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/tvalid_i
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/pkt_ignore
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/set_length
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/data_length
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/version_header
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/dest_ip_addr_l
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/dest_ip_addr_h
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/src_ip_addr
add wave -noupdate -group ip_rx_inst /top/xudp/IP/ip_inst/ip_layer_inst/RX/protocol
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/ip_tx_start
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/ip_tx
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/ip_tx_result
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/ip_tx_tready
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/clk
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/udp_conf
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/arp_req_req
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/arp_req_rslt
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/mac_tx
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/mac_tx_tready
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/wordCntCount
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/wordCntRst
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/wordCntData
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/tx_state
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/next_tx_state
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/total_length
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/set_tx_mac
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/tx_mac
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/tx_mac_reg
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/mac_lookup_req_i
add wave -noupdate -group ip_tx_inst /top/xudp/IP/ip_inst/ip_layer_inst/TX/hdr_checksum
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/arp_req_req
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/arp_req_rslt
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/data_in
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/mac_tx_req
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/mac_tx_granted
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/data_out_ready
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/data_out
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/cfg
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/control
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/req_count
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/clks
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/arp_nwk_req_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/send_I_have_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/arp_entry_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/send_who_has_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/ip_entry_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/arp_store_req_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/arp_store_result_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/nwk_result_status_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/recv_I_have_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/arp_entry_for_I_have_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/recv_who_has_int
add wave -noupdate -group arp_inst /top/xudp/IP/ip_inst/arp_layer_inst/arp_entry_for_who_has_int
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/clk
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/rst
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/axi_in_tready
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/axi_in
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/axi_out
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/axi_out_tready
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/st
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/n_st
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/sel_i
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/sel
add wave -noupdate -group xbar_inst /top/xudp/IP/ip_inst/axi_tx_crossbar_inst/latch_sel
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/send_I_have
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/arp_entry
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/send_who_has
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/ip_entry
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/mac_tx_req
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/mac_tx_granted
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/data_out_ready
add wave -noupdate -group arp_tx_inst -expand /top/xudp/IP/ip_inst/arp_layer_inst/tx/data_out
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/cfg
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/clk
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/reset
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/tx_mac_chn_reqd
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/tx_state
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/tx_count
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/send_I_have_reg
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/send_who_has_reg
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/I_have_target
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/who_has_target
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/tx_mode
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/target
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/timer
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/next_tx_state
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/tx_mode_val
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/target_val
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/tx_count_mode
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/set_chn_reqd
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/set_send_I_have
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/set_send_who_has
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/set_tx_mode
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/set_target
add wave -noupdate -group arp_tx_inst /top/xudp/IP/ip_inst/arp_layer_inst/tx/set_timer
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/data_in
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/recv_who_has
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/arp_entry_for_who_has
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/recv_I_have
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/arp_entry_for_I_have
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/req_count
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/cfg
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/clk
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/reset
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/send_request_needed
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/tx_mac_chn_reqd
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/eop_reg
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/rx_state
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/rx_count
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/arp_operation
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/arp_req_count
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/new_arp_entry
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/arp_err_data
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/set_err_data
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/next_rx_state
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/rx_count_mode
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/set_arp_oper
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/arp_oper_set_val
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/count_arp_rcvd
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/arp_save
add wave -noupdate -group arp_rx_inst /top/xudp/IP/ip_inst/arp_layer_inst/rx/set_eop
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/read_req
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/read_result
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/write_req
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/clear_store
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/entry_count
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/clk
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/reset
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/st_state
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/next_write_addr
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/num_entries
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/next_read_addr
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/entry_found
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/mode
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/req_entry
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/next_st_state
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/arp_entry_val
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/mode_val
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/write_addr
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/read_result_int
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/set_next_write_addr
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/set_num_entries
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/set_next_read_addr
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/write_ram
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/set_entry_found
add wave -noupdate -group arp_store_inst /top/xudp/IP/ip_inst/arp_layer_inst/store/set_mode
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/brd_clk
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_clk
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_clk_locked
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_reset
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/phy_reset
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_in_valid
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_out_valid
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_busy
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_opcode
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_data_in
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_data_out
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mgmt_config
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_cmd_read
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_cmd_write
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_read_data_valid
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_write_data_valid
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_cmd_address
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_cmd_data
add wave -noupdate -group mdio_block /top/xudp/MDIO_BLOCK/mdio_cmd_prtdev_address
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/reset
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/clk
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/phy_reset
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/init_done
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/cmd_read
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/cmd_write
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/cmd_write_data_valid
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/cmd_prtdev_address
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/cmd_address
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/cmd_data
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/state
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/counter
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/init_rom
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/cmd_prt_address
add wave -noupdate -group vsc8486 /top/xudp/MDIO_BLOCK/vsc8486_init_inst/cmd_dev_address
add wave -noupdate -expand -group xaui_init_inst /top/xudp/MDIO_BLOCK/Inst_xaui_init/rstn
add wave -noupdate -expand -group xaui_init_inst /top/xudp/MDIO_BLOCK/Inst_xaui_init/clk156
add wave -noupdate -expand -group xaui_init_inst /top/xudp/MDIO_BLOCK/Inst_xaui_init/status_vector
add wave -noupdate -expand -group xaui_init_inst /top/xudp/MDIO_BLOCK/Inst_xaui_init/config_vector
add wave -noupdate -expand -group xaui_init_inst /top/xudp/MDIO_BLOCK/Inst_xaui_init/st
add wave -noupdate -expand -group xaui_init_inst /top/xudp/MDIO_BLOCK/Inst_xaui_init/reset_rx_link_status
add wave -noupdate -expand -group xaui_init_inst /top/xudp/MDIO_BLOCK/Inst_xaui_init/reset_local_fault
add wave -noupdate /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/xgmii_rxd
add wave -noupdate /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/xgmii_rxc
add wave -noupdate /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/reset_xgmii_tx_n
add wave -noupdate /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/reset_xgmii_rx_n
add wave -noupdate /top/xudp/XGE_MANAGMENT_BLOCK/xge_mac_axi_inst/reset_156m25_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {253046 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 271
configure wave -valuecolwidth 190
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {7965720 ps}
