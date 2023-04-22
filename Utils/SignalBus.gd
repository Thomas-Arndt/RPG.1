extends Node

#Scene Links
signal scene_link_entered(destination_reference)

#Environment Rewards Receivers
signal remove_node(signal_code)
signal add_node(signal_code)
signal modify_node_property(signal_code)

#Switches
signal red_blue_switch_state_changed(signal_code, state, states)

#Camera Effects
signal stop_camera_effect(signal_code)

signal screen_shake(duration, frequency, amplitude, priority)
