# TODO

1. [ ] `config.txt`
2. [ ] `cmdline.txt`
3. [ ] missing module files

  - modules.alias
  - modules.alias.bin  
  - ~~modules.builtin~~  
  - modules.builtin.bin  
  - modules.dep  
  - modules.dep.bin  
  - modules.devname  
  - ~~modules.order~~  
  - modules.softdep  
  - modules.symbols  
  - modules.symbols.bin
4. [ ] docker kernel options

  ```
  Optional Features:
  - CONFIG_USER_NS: enabled
  - CONFIG_SECCOMP: enabled
  - CONFIG_CGROUP_PIDS: missing
  - CONFIG_MEMCG_SWAP: missing
  - CONFIG_MEMCG_SWAP_ENABLED: missing
  - CONFIG_BLK_CGROUP: enabled
  - CONFIG_BLK_DEV_THROTTLING: enabled
  - CONFIG_IOSCHED_CFQ: enabled
  - CONFIG_CFQ_GROUP_IOSCHED: enabled
  - CONFIG_CGROUP_PERF: missing
  - CONFIG_CGROUP_HUGETLB: missing
  - CONFIG_NET_CLS_CGROUP: enabled (as module)
  - CONFIG_CGROUP_NET_PRIO: missing
  - CONFIG_CFS_BANDWIDTH: missing
  - CONFIG_FAIR_GROUP_SCHED: enabled
  - CONFIG_RT_GROUP_SCHED: missing
  - CONFIG_IP_VS: enabled (as module)
  - CONFIG_IP_VS_NFCT: enabled
  - CONFIG_IP_VS_RR: enabled (as module)
  - CONFIG_EXT4_FS: enabled
  - CONFIG_EXT4_FS_POSIX_ACL: enabled
  - CONFIG_EXT4_FS_SECURITY: enabled
  - Network Drivers:
    - "overlay":
      - CONFIG_VXLAN: enabled
        Optional (for encrypted networks):
        - CONFIG_CRYPTO: enabled
        - CONFIG_CRYPTO_AEAD: enabled (as module)
        - CONFIG_CRYPTO_GCM: enabled (as module)
        - CONFIG_CRYPTO_SEQIV: enabled (as module)
        - CONFIG_CRYPTO_GHASH: enabled (as module)
        - CONFIG_XFRM: enabled
        - CONFIG_XFRM_USER: enabled
        - CONFIG_XFRM_ALGO: enabled
        - CONFIG_INET_ESP: enabled (as module)
        - CONFIG_INET_XFRM_MODE_TRANSPORT: enabled (as module)
    - "ipvlan":
      - CONFIG_IPVLAN: missing
    - "macvlan":
      - CONFIG_MACVLAN: enabled (as module)
      - CONFIG_DUMMY: enabled (as module)
    - "ftp,tftp client in container":
      - CONFIG_NF_NAT_FTP: enabled (as module)
      - CONFIG_NF_CONNTRACK_FTP: enabled (as module)
      - CONFIG_NF_NAT_TFTP: enabled (as module)
      - CONFIG_NF_CONNTRACK_TFTP: enabled (as module)
  ```

