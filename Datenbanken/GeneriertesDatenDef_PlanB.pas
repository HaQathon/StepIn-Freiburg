unit GeneriertesDatenDef_PlanB;

{================================================================}
interface
{================================================================}

uses 
  DB, 
  hqDBErweiterungen;


const
  //DA-START:GeneriertesDatenDef_PlanB.constant.tab_systemstrings:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.tab_systemstrings:DA-ELSE
  TAB_SystemStrings = 'TAB_SystemStrings';
  //DA-END:GeneriertesDatenDef_PlanB.constant.tab_systemstrings:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.fd_systemstrings:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.fd_systemstrings:DA-ELSE
  FD_SYSTEMSTRINGS: array[0..4] of ThQFeldDef = 
  ((Name: 'IDSystemStrings' ; FTyp: ftInteger ; Size:   20; Prec: 0; Requ: false; Prim:  true; ELen: 0; Bez: 'IDSystemStrings' ; Art: [FP_Norm]),
   (Name: 'key'             ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'key'             ; Art: [FP_Norm]),
   (Name: 'Text_de'         ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Text_de'         ; Art: [FP_Norm]),
   (Name: 'Text_en'         ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Text_en'         ; Art: [FP_Norm]),
   (Name: 'Text_fr'         ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Text_fr'         ; Art: [FP_Norm]));
  //DA-END:GeneriertesDatenDef_PlanB.constant.fd_systemstrings:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.td_systemstrings:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.td_systemstrings:DA-ELSE
  TD_SYSTEMSTRINGS: ThQTabellenDef = 
  (Name: TAB_SYSTEMSTRINGS; PFDef: @FD_SYSTEMSTRINGS[0]; FDHigh: High(FD_SYSTEMSTRINGS));
  //DA-END:GeneriertesDatenDef_PlanB.constant.td_systemstrings:DA-END
  
  //DA-START:GeneriertesDatenDef_PlanB.constant.tab_strings:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.tab_strings:DA-ELSE
  TAB_Strings = 'TAB_Strings';
  //DA-END:GeneriertesDatenDef_PlanB.constant.tab_strings:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.fd_strings:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.fd_strings:DA-ELSE
  FD_STRINGS: array[0..4] of ThQFeldDef = 
  ((Name: 'IDStrings' ; FTyp: ftInteger ; Size:   20; Prec: 0; Requ: false; Prim:  true; ELen: 0; Bez: 'IDStrings' ; Art: [FP_Norm]),
   (Name: 'key'       ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'key'       ; Art: [FP_Norm]),
   (Name: 'Text_de'   ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Text_de'   ; Art: [FP_Norm]),
   (Name: 'Text_en'   ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Text_en'   ; Art: [FP_Norm]),
   (Name: 'Text_fr'   ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Text_fr'   ; Art: [FP_Norm]));
  //DA-END:GeneriertesDatenDef_PlanB.constant.fd_strings:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.td_strings:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.td_strings:DA-ELSE
  TD_STRINGS: ThQTabellenDef = 
  (Name: TAB_STRINGS; PFDef: @FD_STRINGS[0]; FDHigh: High(FD_STRINGS));
  //DA-END:GeneriertesDatenDef_PlanB.constant.td_strings:DA-END
  
  //DA-START:GeneriertesDatenDef_PlanB.constant.tab_task:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.tab_task:DA-ELSE
  TAB_Task = 'TAB_Task';
  //DA-END:GeneriertesDatenDef_PlanB.constant.tab_task:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.fd_task:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.fd_task:DA-ELSE
  FD_TASK: array[0..3] of ThQFeldDef = 
  ((Name: 'IDTask'   ; FTyp: ftInteger ; Size:   20; Prec: 0; Requ: false; Prim:  true; ELen: 0; Bez: 'IDTask'   ; Art: [FP_Norm]),
   (Name: 'TaskName' ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'TaskName' ; Art: [FP_Norm]),
   (Name: 'TaskInfo' ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'TaskInfo' ; Art: [FP_Norm]),
   (Name: 'Erledigt' ; FTyp: ftBoolean ; Size:    0; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Erledigt' ; Art: [FP_Norm]));
  //DA-END:GeneriertesDatenDef_PlanB.constant.fd_task:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.td_task:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.td_task:DA-ELSE
  TD_TASK: ThQTabellenDef = 
  (Name: TAB_TASK; PFDef: @FD_TASK[0]; FDHigh: High(FD_TASK));
  //DA-END:GeneriertesDatenDef_PlanB.constant.td_task:DA-END
  
  //DA-START:GeneriertesDatenDef_PlanB.constant.tab_attribute:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.tab_attribute:DA-ELSE
  TAB_Attribute = 'TAB_Attribute';
  //DA-END:GeneriertesDatenDef_PlanB.constant.tab_attribute:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.fd_attribute:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.fd_attribute:DA-ELSE
  FD_ATTRIBUTE: array[0..2] of ThQFeldDef = 
  ((Name: 'IDAttribute'  ; FTyp: ftInteger ; Size:   20; Prec: 0; Requ: false; Prim:  true; ELen: 0; Bez: 'IDAttribute'  ; Art: [FP_Norm]),
   (Name: 'Verwendet'    ; FTyp: ftBoolean ; Size:    0; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Verwendet'    ; Art: [FP_Norm]),
   (Name: 'AttributName' ; FTyp: ftInteger ; Size:    0; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'AttributName' ; Art: [FP_Norm]));
  //DA-END:GeneriertesDatenDef_PlanB.constant.fd_attribute:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.td_attribute:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.td_attribute:DA-ELSE
  TD_ATTRIBUTE: ThQTabellenDef = 
  (Name: TAB_ATTRIBUTE; PFDef: @FD_ATTRIBUTE[0]; FDHigh: High(FD_ATTRIBUTE));
  //DA-END:GeneriertesDatenDef_PlanB.constant.td_attribute:DA-END
  
  //DA-START:GeneriertesDatenDef_PlanB.constant.tab_taskattributerel:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.tab_taskattributerel:DA-ELSE
  TAB_TaskAttributeRel = 'TAB_TaskAttributeRel';
  //DA-END:GeneriertesDatenDef_PlanB.constant.tab_taskattributerel:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.fd_taskattributerel:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.fd_taskattributerel:DA-ELSE
  FD_TASKATTRIBUTEREL: array[0..2] of ThQFeldDef = 
  ((Name: 'IDTaskAttribute' ; FTyp: ftInteger ; Size:   20; Prec: 0; Requ: false; Prim:  true; ELen: 0; Bez: 'IDTaskAttribute' ; Art: [FP_Norm]),
   (Name: 'IDTask'          ; FTyp: ftInteger ; Size:    0; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'IDTask'          ; Art: [FP_Norm]),
   (Name: 'AttributeID'     ; FTyp: ftInteger ; Size:    0; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'AttributeID'     ; Art: [FP_Norm]));
  //DA-END:GeneriertesDatenDef_PlanB.constant.fd_taskattributerel:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.td_taskattributerel:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.td_taskattributerel:DA-ELSE
  TD_TASKATTRIBUTEREL: ThQTabellenDef = 
  (Name: TAB_TASKATTRIBUTEREL; PFDef: @FD_TASKATTRIBUTEREL[0]; FDHigh: High(FD_TASKATTRIBUTEREL));
  //DA-END:GeneriertesDatenDef_PlanB.constant.td_taskattributerel:DA-END
  
  //DA-START:GeneriertesDatenDef_PlanB.constant.tab_taskcontentrel:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.tab_taskcontentrel:DA-ELSE
  TAB_TaskContentRel = 'TAB_TaskContentRel';
  //DA-END:GeneriertesDatenDef_PlanB.constant.tab_taskcontentrel:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.fd_taskcontentrel:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.fd_taskcontentrel:DA-ELSE
  FD_TASKCONTENTREL: array[0..1] of ThQFeldDef = 
  ((Name: 'IDContent' ; FTyp: ftInteger ; Size:   20; Prec: 0; Requ: false; Prim:  true; ELen: 0; Bez: 'IDContent' ; Art: [FP_Norm]),
   (Name: 'Inhalt'    ; FTyp: ftString  ; Size:  100; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'Inhalt'    ; Art: [FP_Norm]));
  //DA-END:GeneriertesDatenDef_PlanB.constant.fd_taskcontentrel:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.td_taskcontentrel:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.td_taskcontentrel:DA-ELSE
  TD_TASKCONTENTREL: ThQTabellenDef = 
  (Name: TAB_TASKCONTENTREL; PFDef: @FD_TASKCONTENTREL[0]; FDHigh: High(FD_TASKCONTENTREL));
  //DA-END:GeneriertesDatenDef_PlanB.constant.td_taskcontentrel:DA-END
  
  //DA-START:GeneriertesDatenDef_PlanB.constant.tab_content:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.tab_content:DA-ELSE
  TAB_Content = 'TAB_Content';
  //DA-END:GeneriertesDatenDef_PlanB.constant.tab_content:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.fd_content:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.fd_content:DA-ELSE
  FD_CONTENT: array[0..2] of ThQFeldDef = 
  ((Name: 'IDTaskContent' ; FTyp: ftInteger ; Size:   20; Prec: 0; Requ: false; Prim:  true; ELen: 0; Bez: 'IDTaskContent' ; Art: [FP_Norm]),
   (Name: 'IDContent'     ; FTyp: ftInteger ; Size:    0; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'IDContent'     ; Art: [FP_Norm]),
   (Name: 'IDTask'        ; FTyp: ftInteger ; Size:    0; Prec: 0; Requ: false; Prim: false; ELen: 0; Bez: 'IDTask'        ; Art: [FP_Norm]));
  //DA-END:GeneriertesDatenDef_PlanB.constant.fd_content:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.td_content:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.td_content:DA-ELSE
  TD_CONTENT: ThQTabellenDef = 
  (Name: TAB_CONTENT; PFDef: @FD_CONTENT[0]; FDHigh: High(FD_CONTENT));
  //DA-END:GeneriertesDatenDef_PlanB.constant.td_content:DA-END
  
  //DA-START:GeneriertesDatenDef_PlanB.constant.anztabellen:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.anztabellen:DA-ELSE
  AnzTabellen = 7;
  //DA-END:GeneriertesDatenDef_PlanB.constant.anztabellen:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.anzviews:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.anzviews:DA-ELSE
  AnzViews = 0;
  //DA-END:GeneriertesDatenDef_PlanB.constant.anzviews:DA-END
  //DA-START:GeneriertesDatenDef_PlanB.constant.anzindex:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.constant.anzindex:DA-ELSE
  AnzIndex = 0;
  //DA-END:GeneriertesDatenDef_PlanB.constant.anzindex:DA-END


{================================================================}
implementation
{================================================================}

initialization
  //DA-START:GeneriertesDatenDef_PlanB.additional.initializations.in.unit:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.additional.initializations.in.unit:DA-ELSE
  //DA-END:GeneriertesDatenDef_PlanB.additional.initializations.in.unit:DA-END
finalization
  //DA-START:GeneriertesDatenDef_PlanB.additional.finalizations.in.unit:DA-START
  //DA-ELSE:GeneriertesDatenDef_PlanB.additional.finalizations.in.unit:DA-ELSE
  //DA-END:GeneriertesDatenDef_PlanB.additional.finalizations.in.unit:DA-END
end.
