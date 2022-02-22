# RF : Register File

| Number (4 bit) | Register |
| :----: | :------: |
|  `0`   |  `%rax`  |
|  `1`   |  `%rcx`  |
|  `2`   |  `%rdx`  |
|  `3`   |  `%rbx`  |
|  `4`   |  `%rsp`  |
|  `5`   |  `%rbp`  |
|  `6`   |  `%rsi`  |
|  `7`   |  `%rdi`  |
|  `8`   |  `%r8`   |
|  `9`   |  `%r9`   |
|  `a`   |  `%r10`  |
|  `b`   |  `%r11`  |
|  `c`   |  `%r12`  |
|  `d`   |  `%r13`  |
|  `e`   |  `%r14`  |
|  `f`   |   None   |

# CC : Condition Codes

| Flags (1 bit) |    Meaning    |
| :--: | :-----------: |
|  ZF  |   Zero Flag   |
|  SF  |   Sign Flag   |
|  OF  | Overflow Flag |

# Stat : Program Status

| Value | Name  |             Meaning             |
| :---: | :---: | :-----------------------------: |
|   1   | `AOK` |        Normal Operation         |
|   2   | `HLT` | `halt` instruction encountered  |
|   3   | `ADR` |   Invalid address encountered   |
|   4   | `INS` | Invalid instruction encountered |

# Instructions

## Halt and No Operation
| Code | Instruction |
| :--: | :---------: |
| `00` |   `halt`    |
| `10` |    `nop`    |

## Moves

| Code | Instruction |
| :--: | :---------: |
| `20` |  `rrmovq`   |
| `21` |  `cmovle`   |
| `22` |   `cmovl`   |
| `23` |   `cmove`   |
| `24` |  `cmovne`   |
| `25` |  `cmovge`   |
| `26` |   `cmovg`   |
| `30` |  `irmovq`   |
| `40` |  `rmmovq`   |
| `50` |  `mrmovq`   |

## Operations

| Code | Instruction |
| :--: | :---------: |
| `60` |   `addq`    |
| `61` |   `subq`    |
| `62` |   `andq`    |
| `63` |   `xorq`    |

## Branches

| Code | Instruction |
| :--: | :---------: |
| `70` |    `jmp`    |
| `71` |    `jle`    |
| `72` |    `jl`     |
| `73` |    `je`     |
| `74` |    `jne`    |
| `75` |    `jge`    |
| `76` |    `jg`     |

## Call and Return

| Code | Instruction |
| :--: | :---------: |
| `80` |   `call`    |
| `90` |    `ret`    |

## Stack Operations

| Code | Instruction |
| :--: | :---------: |
| `A0` |   `pushq`   |
| `B0` |   `popq`    |