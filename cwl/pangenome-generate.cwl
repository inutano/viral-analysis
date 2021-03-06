cwlVersion: v1.1
class: Workflow
inputs:
  inputReads: File[]
outputs:
  odgiGraph:
    type: File
    outputSource: buildGraph/odgiGraph
  odgiPNG:
    type: File
    outputSource: vizGraph/odgiPNG
  seqwishGFA:
    type: File
    outputSource: induceGraph/seqwishGFA
steps:
  dedup:
    in: {readsFA: inputReads}
    out: [readsMergeDedup]
    run: seqkit-rmdup.cwl
  overlapReads:
    in: {readsFA: dedup/readsMergeDedup}
    out: [readsPAF]
    run: minimap2.cwl
  induceGraph:
    in:
      readsFA: dedup/readsMergeDedup
      readsPAF: overlapReads/readsPAF
    out: [seqwishGFA]
    run: seqwish.cwl
  buildGraph:
    in: {inputGFA: induceGraph/seqwishGFA}
    out: [odgiGraph]
    run: odgi-build.cwl
  vizGraph:
    in: {inputODGI: buildGraph/odgiGraph}
    out: [odgiPNG]
    run: odgi-viz.cwl
