#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
# Use of this source code is governed by an MIT-style license, details of
# which can be found in the project LICENSE file
#

require 'thread'

require_relative 'lib_config'

# ----------------------------------------------------------------------------
# networking library
#
module LibNetwork
  # ----------------------------------------------------------------------------
  # use ping (ICMP) to ping the address range passed in and freshen up the
  # local arp cache
  #
  def self.ping_hosts(ip_base, ip_range)
    children = ip_range.map do |n|
      address = ip_base + n.to_s
      spawn("ping -q -W 1 -c 1 #{address} > /dev/null 2>&1")
    end
    children.each do |pid|
      Process.wait(pid)
    end
    nil
  end

  # ----------------------------------------------------------------------------
  # use arp to find mac addressed passed in, returning true if any mac passed
  # in is found (e.g., mac1 | mac2 | mac3)
  #
  def self.find_macs?(macs_to_find)
    mac_list_regex = ''

    macs_to_find.each_with_index do |val, idx|
      mac_list_regex += val
      mac_list_regex += '\|' if idx < (macs_to_find.count - 1)
    end

    results = `#{LibConfig::ARP} -n | #{LibConfig::GREP} -E #{mac_list_regex}`
    !results.empty?
  end
end
