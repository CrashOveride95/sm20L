OUTPUT_ARCH (mips)

/* include/segments.h defines SEG_POOL_START, SEG_POOL_END, SEG_BUFFERS,
 * SEG_GODDARD, SEG_MAIN, SEG_ENGINE, SEG_FRAMEBUFFERS */
#include "segments.h"

#define BEGIN_SEG(name, addr) \
    _##name##SegmentStart = ADDR(.name); \
    _##name##SegmentRomStart = __romPos; \
    .name addr : AT(__romPos)

#define END_SEG(name) \
    _##name##SegmentEnd = ADDR(.name) + SIZEOF(.name); \
    _##name##SegmentRomEnd = __romPos + SIZEOF(.name); \
    __romPos += SIZEOF(.name);

#define BEGIN_NOLOAD(name) \
    _##name##SegmentNoloadStart = ADDR(.name.noload); \
    .name.noload (NOLOAD) :

#define END_NOLOAD(name) \
    _##name##SegmentNoloadEnd = ADDR(.name.noload) + SIZEOF(.name.noload);

#define MIO0_SEG(name, segAddr) \
   BEGIN_SEG(name##_mio0, segAddr) \
   { \
      BUILD_DIR/bin/name.mio0.o(.data); \
      . = ALIGN(0x10); \
   } \
   END_SEG(name##_mio0)

#define MIO0_EU_SEG(name, segAddr) \
   BEGIN_SEG(name##_mio0, segAddr) \
   { \
      BUILD_DIR/bin/eu/name.mio0.o(.data); \
      . = ALIGN(0x10); \
   } \
   END_SEG(name##_mio0)

#define STANDARD_LEVEL(name) \
   BEGIN_SEG(name##_segment_7, 0x07000000) \
   { \
      BUILD_DIR/levels/name/leveldata.mio0.o(.data); \
      . = ALIGN(0x10); \
   } \
   END_SEG(name##_segment_7) \
   BEGIN_SEG(name, 0x0E000000) \
   { \
      BUILD_DIR/levels/name/script.o(.data); \
      BUILD_DIR/levels/name/geo.o(.data); \
   } \
   END_SEG(name)

#define STANDARD_OBJECTS(name, segAddr, geoAddr) \
   BEGIN_SEG(name##_mio0, segAddr) \
   { \
      BUILD_DIR/actors/name.mio0.o(.data); \
      . = ALIGN(0x10); \
   } \
   END_SEG(name##_mio0) \
   BEGIN_SEG(name##_geo, geoAddr) \
   { \
      BUILD_DIR/actors/name##_geo.o(.data); \
   } \
   END_SEG(name##_geo)

SECTIONS
{
   __romPos = 0;

   BEGIN_SEG(boot, 0x04000000)
   {
      BUILD_DIR/asm/rom_header.o(.text);
      BUILD_DIR/asm/boot.o(.text);
   }
   END_SEG(boot)

   . = 0x80000400;
   BEGIN_NOLOAD(zbuffer) {
      BUILD_DIR/src/buffers/zbuffer.o(.bss*);
   }

   /* lib/src/__osDevMgrMain.c and lib/src/osCreateViManager.c contain infinite
    * loops compiled without -g, which cause the return statements and the .o
    * files themselves to be aligned to 32-byte boundaries. But in the binary,
    * they are actually aligned only to 16 bytes! We force this to happen using
    * a SUBALIGN directive. */
   BEGIN_SEG(main, SEG_MAIN) SUBALIGN(16)
   {
      BUILD_DIR/asm/entry.o(.text);
      BUILD_DIR/src/game/crash_screen.o(.text);
      BUILD_DIR/src/game/main.o(.text);
      BUILD_DIR/src/game/display.o(.text);
      BUILD_DIR/src/game/game.o(.text);
      BUILD_DIR/src/game/sound_init.o(.text);
      BUILD_DIR/src/game/level_update.o(.text);
      BUILD_DIR/src/game/interaction.o(.text);
      BUILD_DIR/src/game/mario.o(.text);
      BUILD_DIR/src/game/mario_step.o(.text);
      BUILD_DIR/src/game/mario_actions_cutscene.o(.text);
      BUILD_DIR/src/game/mario_actions_automatic.o(.text);
      BUILD_DIR/src/game/mario_actions_stationary.o(.text);
      BUILD_DIR/src/game/mario_actions_moving.o(.text);
      BUILD_DIR/src/game/mario_actions_airborne.o(.text);
      BUILD_DIR/src/game/mario_actions_submerged.o(.text);
      BUILD_DIR/src/game/mario_actions_object.o(.text);
      BUILD_DIR/src/game/level_geo.o(.text);
      BUILD_DIR/src/game/mario_misc.o(.text);
      BUILD_DIR/src/game/memory.o(.text);
      BUILD_DIR/src/game/save_file.o(.text);
      BUILD_DIR/src/game/area.o(.text);
      BUILD_DIR/src/game/rendering_graph_node.o(.text);
      BUILD_DIR/src/game/profiler.o(.text);
      BUILD_DIR/asm/decompress.o(.text);
      BUILD_DIR/src/game/camera.o(.text);
      BUILD_DIR/src/game/debug_course.o(.text);
      BUILD_DIR/src/game/object_list_processor.o(.text);
#ifndef VERSION_EU
      BUILD_DIR/src/game/object_helpers.o(.text);
#endif
      BUILD_DIR/src/game/behavior_actions.o(.text);
      BUILD_DIR/src/game/platform_displacement.o(.text);
#ifndef VERSION_EU
      BUILD_DIR/src/game/object_collision.o(.text);
      BUILD_DIR/src/game/spawn_object.o(.text);
#endif
      BUILD_DIR/src/game/spawn_sound.o(.text);
      BUILD_DIR/src/game/debug.o(.text);
      BUILD_DIR/src/game/screen_transition.o(.text);
      BUILD_DIR/src/game/shadow.o(.text);
      BUILD_DIR/src/game/skybox.o(.text);
      BUILD_DIR/src/game/moving_texture.o(.text);
      BUILD_DIR/src/game/geo_misc.o(.text);
      BUILD_DIR/src/game/paintings.o(.text);
      BUILD_DIR/src/game/print.o(.text);
      BUILD_DIR/src/game/ingame_menu.o(.text);
      BUILD_DIR/src/game/envfx_snow.o(.text);
      BUILD_DIR/src/game/envfx_bubbles.o(.text);
      BUILD_DIR/src/game/macro_special_objects.o(.text);
      BUILD_DIR/src/game/hud.o(.text);
      BUILD_DIR/src/game/obj_behaviors.o(.text);
      BUILD_DIR/src/game/obj_behaviors_2.o(.text);
      BUILD_DIR/src/audio/synthesis.o(.text);
      BUILD_DIR/src/audio/memory.o(.text);
      BUILD_DIR/src/audio/load.o(.text);
      BUILD_DIR/src/audio/playback.o(.text);
      BUILD_DIR/src/audio/effects.o(.text);
      BUILD_DIR/src/audio/seqplayer.o(.text);
      BUILD_DIR/src/audio/external.o(.text);
      BUILD_DIR/src/audio/port_eu.o(.text);
#ifdef VERSION_EU
      lib/libultra_rom.a:string.o(.text);
      lib/libultra_rom.a:_Printf.o(.text);
      lib/libultra_rom.a:llmuldiv.o(.text);
      lib/libultra_rom.a:osInitialize.o(.text);
      lib/libultra_rom.a:osSetTime.o(.text);
      lib/libultra_rom.a:osGetTime.o(.text);
      lib/libultra_rom.a:osWritebackDCacheAll.o(.text);
      lib/libultra_rom.a:osViBlack.o(.text);
      lib/libultra_rom.a:osViSwapBuffer.o(.text);
      lib/libultra_rom.a:__osGetCurrFaultedThread.o(.text);
      lib/libultra_rom.a:osSetEventMesg.o(.text);
      lib/libultra_rom.a:osRecvMesg.o(.text);
      lib/libultra_rom.a:parameters.o(.text);
      lib/libultra_rom.a:osCreateMesgQueue.o(.text);
      lib/libultra_rom.a:osCreateThread.o(.text);
      lib/libultra_rom.a:osStartThread.o(.text);
      lib/libultra_rom.a:osMapTLB.o(.text);
      lib/libultra_rom.a:osUnmapTLBAll.o(.text);
      lib/libultra_rom.a:sprintf.o(.text);
      lib/libultra_rom.a:osViSetEvent.o(.text);
      lib/libultra_rom.a:osSpTaskLoadGo.o(.text);
      lib/libultra_rom.a:osSpTaskYield.o(.text);
      lib/libultra_rom.a:osSendMesg.o(.text);
      lib/libultra_rom.a:osSpTaskYielded.o(.text);
      lib/libultra_rom.a:osCreateViManager.o(.text);
      lib/libultra_rom.a:osViSetMode.o(.text);
      lib/libultra_rom.a:osViSetSpecialFeatures.o(.text);
      lib/libultra_rom.a:osCreatePiManager.o(.text);
      lib/libultra_rom.a:osSetThreadPri.o(.text);
      lib/libultra_rom.a:osViSwapBuffer.o(.text);
      lib/libultra_rom.a:sqrtf.o(.text);
      lib/libultra_rom.a:osContStartReadData.o(.text);
      lib/libultra_rom.a:osContInit.o(.text);
      lib/libultra_rom.a:osEepromProbe.o(.text);
      lib/libultra_rom.a:osInvalDCache.o(.text);
      lib/libultra_rom.a:osPiStartDma.o(.text);
      lib/libultra_rom.a:bzero.o(.text)
      lib/libultra_rom.a:osInvalICache.o(.text)
      lib/libultra_rom.a:osEepromLongRead.o(.text)
      lib/libultra_rom.a:osEepromLongWrite.o(.text)
      lib/libultra_rom.a:bcopy.o(.text)
      lib/libultra_rom.a:guOrthoF.o(.text)
      lib/libultra_rom.a:guPerspectiveF.o(.text)
      lib/libultra_rom.a:llconv.o(.text)
      lib/libultra_rom.a:cosf.o(.text)
      lib/libultra_rom.a:sinf.o(.text)
      lib/libultra_rom.a:guTranslateF.o(.text)
      lib/libultra_rom.a:guRotateF.o(.text)
      lib/libultra_rom.a:guScaleF.o(.text)
      lib/libultra_rom.a:osAiSetFrequency.o(.text)
      lib/libultra_rom.a:alBnkfNew.o(.text)
      lib/libultra_rom.a:osAiGetLength.o(.text)
      lib/libultra_rom.a:osAiSetNextBuffer.o(.text)
      lib/libultra_rom.a:_Litob.o(.text)
      lib/libultra_rom.a:_Ldtob.o(.text)
      lib/libultra_rom.a:__osSetSR.o(.text)
      lib/libultra_rom.a:__osGetSR.o(.text)
      lib/libultra_rom.a:__osSetFpcCsr.o(.text)
      lib/libultra_rom.a:__osSiRawReadIo.o(.text)
      lib/libultra_rom.a:__osSiRawWriteIo.o(.text)
      lib/libultra_rom.a:__osExceptionPreamble.o(.text)
      lib/libultra_rom.a:osWritebackDCache.o(.text)
      lib/libultra_rom.a:osMapTLBRdb.o(.text)
      lib/libultra_rom.a:osPiRawReadIo.o(.text)
      lib/libultra_rom.a:EU_D_802f4330.o(.text)
      lib/libultra_rom.a:D_802F4380.o(.text)
      lib/libultra_rom.a:func_802F4A20.o(.text)
      lib/libultra_rom.a:osTimer.o(.text)
      lib/libultra_rom.a:__osDisableInt.o(.text)
      lib/libultra_rom.a:__osRestoreInt.o(.text)
      lib/libultra_rom.a:osGetCount.o(.text)
      lib/libultra_rom.a:__osViInit.o(.text)
      lib/libultra_rom.a:__osDequeueThread.o(.text)
      lib/libultra_rom.a:osVirtualToPhysical.o(.text)
      lib/libultra_rom.a:__osSpSetStatus.o(.text)
      lib/libultra_rom.a:__osSpSetPc.o(.text)
      lib/libultra_rom.a:__osSpRawStartDma.o(.text)
      lib/libultra_rom.a:__osSpDeviceBusy.o(.text)
      lib/libultra_rom.a:__osSpGetStatus.o(.text)
      lib/libultra_rom.a:osGetThreadPri.o(.text)
      lib/libultra_rom.a:__osViGetCurrentContext.o(.text);
      lib/libultra_rom.a:__osViSwapContext.o(.text)
      lib/libultra_rom.a:__osPiCreateAccessQueue.o(.text)
      lib/libultra_rom.a:osPiRawStartDma.o(.text)
      lib/libultra_rom.a:osEPiRawStartDma.o(.text)
      lib/libultra_rom.a:__osDevMgrMain.o(.text)
      lib/libultra_rom.a:__osSiCreateAccessQueue.o(.text)
      lib/libultra_rom.a:__osSiRawStartDma.o(.text)
      lib/libultra_rom.a:osSetTimer.o(.text)
      lib/libultra_rom.a:osEepromWrite.o(.text)
      lib/libultra_rom.a:osJamMesg.o(.text)
      lib/libultra_rom.a:osPiGetCmdQueue.o(.text)
      lib/libultra_rom.a:osEepromRead.o(.text)
      lib/libultra_rom.a:guMtxF2L.o(.text)
      lib/libultra_rom.a:guNormalize.o(.text)
      lib/libultra_rom.a:__osAiDeviceBusy.o(.text);
      lib/libultra_rom.a:ldiv.o(.text)
      lib/libultra_rom.a:__osSiDeviceBusy.o(.text);
      lib/libultra_rom.a:osSetIntMask.o(.text)
      lib/libultra_rom.a:osDestroyThread.o(.text)
      lib/libultra_rom.a:osLeoDiskInit.o(.text)
      lib/libultra_rom.a:__osSetCompare.o(.text)
      lib/libultra_rom.a:__osProbeTLB.o(.text)
      lib/libultra_rom.a:__osDequeueThread.o(.text)
      lib/libultra_rom.a:func_802F7140.o(.text)
      lib/libultra_rom.a:func_802F71A0.o(.text)
      lib/libultra_rom.a:func_802F71F0.o(.text)

      BUILD_DIR/lib/rsp.o(.text);

#else
      BUILD_DIR/src/game*.o(.text);
      BUILD_DIR/src/audio*.o(.text);
	  /* .text */
      lib/libultra_rom.a:aigetlen.o(.text);
      lib/libultra_rom.a:aisetfreq.o(.text);
      lib/libultra_rom.a:aisetnextbuf.o(.text);
      lib/libultra_rom.a:bcopy.o(.text);
      lib/libultra_rom.a:bnkf.o(.text);
      lib/libultra_rom.a:bzero.o(.text);
      lib/libultra_rom.a:conteeplongread.o(.text);
      lib/libultra_rom.a:conteeplongwrite.o(.text);
      lib/libultra_rom.a:conteepprobe.o(.text);
      lib/libultra_rom.a:controller.o(.text);
      lib/libultra_rom.a:cosf.o(.text);
      lib/libultra_rom.a:createmesgqueue.o(.text);
      lib/libultra_rom.a:createthread.o(.text);
      lib/libultra_rom.a:gettime.o(.text);
      lib/libultra_rom.a:initialize.o(.text);
      lib/libultra_rom.a:invaldcache.o(.text);
      lib/libultra_rom.a:ll.o(.text);
      lib/libultra_rom.a:llcvt.o(.text);
      lib/libultra_rom.a:maptlb.o(.text);
      lib/libultra_rom.a:mtxf2l.o(.text);
      lib/libultra_rom.a:ortho.o(.text);
      lib/libultra_rom.a:perspective.o(.text);
      lib/libultra_rom.a:pidma.o(.text);
      lib/libultra_rom.a:recvmesg.o(.text);
      lib/libultra_rom.a:rotate.o(.text);
      lib/libultra_rom.a:scale.o(.text);
      lib/libultra_rom.a:sendmesg.o(.text);
      lib/libultra_rom.a:seteventmesg.o(.text);
      lib/libultra_rom.a:setthreadpri.o(.text);
      lib/libultra_rom.a:settime.o(.text);
      lib/libultra_rom.a:sinf.o(.text);
      lib/libultra_rom.a:sprintf.o(.text);
      lib/libultra_rom.a:sptask.o(.text);
      lib/libultra_rom.a:sptaskyield.o(.text);
      lib/libultra_rom.a:sptaskyielded.o(.text);
      lib/libultra_rom.a:sqrtf.o(.text);
      lib/libultra_rom.a:startthread.o(.text);
      lib/libultra_rom.a:translate.o(.text);
      lib/libultra_rom.a:unmaptlball.o(.text);
      lib/libultra_rom.a:viblack.o(.text);
      lib/libultra_rom.a:vimgr.o(.text);
      lib/libultra_rom.a:virtualtophysical.o(.text);
      lib/libultra_rom.a:visetevent.o(.text);
      lib/libultra_rom.a:visetmode.o(.text);
      lib/libultra_rom.a:visetspecial.o(.text);
      lib/libultra_rom.a:viswapbuf.o(.text);
      lib/libultra_rom.a:writebackdcache.o(.text);
      lib/libultra_rom.a:writebackdcacheall.o(.text);
      /* .data */
      lib/libultra_rom.a:vitbl.o(.data);
      lib/libultra_rom.a:initialize.o(.data);
      lib/libultra_rom.a:parameters.o(.text);
      lib/libultra_rom.a:osSetTime.o(.text);
      lib/libultra_rom.a:osMapTLB.o(.text);
      lib/libultra_rom.a:osUnmapTLBAll.o(.text);
      lib/libultra_rom.a:sprintf.o(.text);
      lib/libultra_rom.a:osCreateMesgQueue.o(.text);
      lib/libultra_rom.a:osSetEventMesg.o(.text);
      lib/libultra_rom.a:osViSetEvent.o(.text);
      lib/libultra_rom.a:osCreateThread.o(.text);
      lib/libultra_rom.a:osRecvMesg.o(.text);
      lib/libultra_rom.a:osSpTaskLoadGo.o(.text);
      lib/libultra_rom.a:osSpTaskYield.o(.text);
      lib/libultra_rom.a:osSendMesg.o(.text);
      lib/libultra_rom.a:osSpTaskYielded.o(.text);
      lib/libultra_rom.a:osStartThread.o(.text);
      lib/libultra_rom.a:osWritebackDCacheAll.o(.text);
      lib/libultra_rom.a:osCreateViManager.o(.text);
      lib/libultra_rom.a:osViSetMode.o(.text);
      lib/libultra_rom.a:osViBlack.o(.text);
      lib/libultra_rom.a:osViSetSpecialFeatures.o(.text);
      lib/libultra_rom.a:osCreatePiManager.o(.text);
      lib/libultra_rom.a:osSetThreadPri.o(.text);
      lib/libultra_rom.a:osInitialize.o(.text);
      lib/libultra_rom.a:osViSwapBuffer.o(.text);
      lib/libultra_rom.a:sqrtf.o(.text);
      lib/libultra_rom.a:osContStartReadData.o(.text);
      lib/libultra_rom.a:osContInit.o(.text);
      lib/libultra_rom.a:osEepromProbe.o(.text);
      lib/libultra_rom.a:llmuldiv.o(.text);
      lib/libultra_rom.a:osInvalDCache.o(.text);
      lib/libultra_rom.a:osPiStartDma.o(.text);
      lib/libultra_rom.a:bzero.o(.text);
      lib/libultra_rom.a:osInvalICache.o(.text);
      lib/libultra_rom.a:osEepromLongRead.o(.text);
      lib/libultra_rom.a:osEepromLongWrite.o(.text);
      lib/libultra_rom.a:bcopy.o(.text);
      lib/libultra_rom.a:guOrthoF.o(.text);
      lib/libultra_rom.a:guPerspectiveF.o(.text);
      lib/libultra_rom.a:osGetTime.o(.text);
      lib/libultra_rom.a:llconv.o(.text);
      lib/libultra_rom.a:cosf.o(.text);
      lib/libultra_rom.a:sinf.o(.text);
      lib/libultra_rom.a:guTranslateF.o(.text);
      lib/libultra_rom.a:guRotateF.o(.text);
      lib/libultra_rom.a:guScaleF.o(.text);
#ifndef VERSION_EU
      lib/libultra_rom.a:osAiSetFrequency.o(.text);
#endif
      lib/libultra_rom.a:alBnkfNew.o(.text);
      lib/libultra_rom.a:osWritebackDCache.o(.text);
      lib/libultra_rom.a:osAiGetLength.o(.text);
      lib/libultra_rom.a:osAiSetNextBuffer.o(.text);
      lib/libultra_rom.a:osTimer.o(.text);
      lib/libultra_rom.a:_Printf.o(.text);
      lib/libultra_rom.a:string.o(.text);
      lib/libultra_rom.a:__osDequeueThread.o(.text);
      lib/libultra_rom.a:__osDisableInt.o(.text);
      lib/libultra_rom.a:__osRestoreInt.o(.text);
      lib/libultra_rom.a:__osViInit.o(.text);
      lib/libultra_rom.a:__osExceptionPreamble.o(.text);
      lib/libultra_rom.a:osVirtualToPhysical.o(.text);
      lib/libultra_rom.a:__osSpSetStatus.o(.text);
      lib/libultra_rom.a:__osSpSetPc.o(.text);
      lib/libultra_rom.a:__osSpRawStartDma.o(.text);
      lib/libultra_rom.a:__osSpDeviceBusy.o(.text);
      lib/libultra_rom.a:__osSpGetStatus.o(.text);
      lib/libultra_rom.a:osGetThreadPri.o(.text);
      lib/libultra_rom.a:__osViGetCurrentContext.o(.text);
      lib/libultra_rom.a:__osViSwapContext.o(.text);
      lib/libultra_rom.a:osGetCount.o(.text);
      lib/libultra_rom.a:__osPiCreateAccessQueue.o(.text);
      lib/libultra_rom.a:osPiRawStartDma.o(.text);
      lib/libultra_rom.a:__osDevMgrMain.o(.text);
      lib/libultra_rom.a:__osSetSR.o(.text);
      lib/libultra_rom.a:__osGetSR.o(.text);
      lib/libultra_rom.a:__osSetFpcCsr.o(.text);
      lib/libultra_rom.a:__osSiRawReadIo.o(.text);
      lib/libultra_rom.a:__osSiRawWriteIo.o(.text);
      lib/libultra_rom.a:osMapTLBRdb.o(.text);
      lib/libultra_rom.a:osPiRawReadIo.o(.text);
#if VERSION_JP
      . += 0x40;
#endif
      lib/libultra_rom.a:__osSiCreateAccessQueue.o(.text);
      lib/libultra_rom.a:__osSiRawStartDma.o(.text);
      lib/libultra_rom.a:osSetTimer.o(.text);
      lib/libultra_rom.a:osEepromWrite.o(.text);
      lib/libultra_rom.a:osJamMesg.o(.text);
      lib/libultra_rom.a:osPiGetCmdQueue.o(.text);
      lib/libultra_rom.a:osEepromRead.o(.text);
      lib/libultra_rom.a:guMtxF2L.o(.text);
      lib/libultra_rom.a:guMtxIdentF.o(.text);
      lib/libultra_rom.a:guNormalize.o(.text);
      lib/libultra_rom.a:__osAiDeviceBusy.o(.text);
      lib/libultra_rom.a:__osSetCompare.o(.text);
      lib/libultra_rom.a:_Litob.o(.text);
      lib/libultra_rom.a:_Ldtob.o(.text);
      lib/libultra_rom.a:kdebugserver.o(.text);
      lib/libultra_rom.a:__osSyncPutChars.o(.text);
      lib/libultra_rom.a:osSetIntMask.o(.text);
      lib/libultra_rom.a:osDestroyThread.o(.text);
      lib/libultra_rom.a:__osProbeTLB.o(.text);
      lib/libultra_rom.a:__osSiDeviceBusy.o(.text);
      lib/libultra_rom.a:ldiv.o(.text);
      lib/libultra_rom.a:__osGetCause.o(.text);
      lib/libultra_rom.a:__osAtomicDec.o(.text);
      lib/libultra_rom.a:guLookAtRef.o(.text); /* Fast3DEX2 only */
      BUILD_DIR/lib/rsp.o(.text);
#endif

      /* data */
      BUILD_DIR/src/game/crash_screen.o(.data*);
      BUILD_DIR/src/game/main.o(.data*);
      BUILD_DIR/src/game/display.o(.data*);
      BUILD_DIR/src/game/game.o(.data*);
      BUILD_DIR/src/game/sound_init.o(.data*);
      BUILD_DIR/src/game/level_update.o(.data*);
      BUILD_DIR/src/game/interaction.o(.data*);
      BUILD_DIR/src/game/mario.o(.data*);
      BUILD_DIR/src/game/mario_step.o(.data*);
      BUILD_DIR/src/game/mario_actions_cutscene.o(.data*);
      BUILD_DIR/src/game/mario_actions_moving.o(.data*);
      BUILD_DIR/src/game/mario_actions_submerged.o(.data*);
      BUILD_DIR/src/game/mario_actions_object.o(.data*);
      BUILD_DIR/src/game/mario_misc.o(.data*);
      BUILD_DIR/src/game/memory.o(.data*);
      BUILD_DIR/src/game/save_file.o(.data*);
      BUILD_DIR/src/game/area.o(.data*);
      BUILD_DIR/src/game/rendering_graph_node.o(.data*);
      BUILD_DIR/src/game/profiler.o(.data*);
      BUILD_DIR/src/game/camera.o(.data*);
      BUILD_DIR/src/game/object_list_processor.o(.data*);
#ifndef VERSION_EU
      BUILD_DIR/src/game/object_helpers.o(.data*);
#endif
      BUILD_DIR/src/game/behavior_actions.o(.data*);
      BUILD_DIR/src/game/platform_displacement.o(.data*);
      BUILD_DIR/src/game/spawn_sound.o(.data*);
      BUILD_DIR/src/game/debug.o(.data*);
      BUILD_DIR/src/game/screen_transition.o(.data*);
      BUILD_DIR/src/game/shadow.o(.data*);
      BUILD_DIR/src/game/skybox.o(.data*);
      BUILD_DIR/src/game/moving_texture.o(.data*);
      BUILD_DIR/src/game/geo_misc.o(.data*);
      BUILD_DIR/src/game/paintings.o(.data*);
      BUILD_DIR/src/game/print.o(.data*);
      BUILD_DIR/src/game/ingame_menu.o(.data*);
      BUILD_DIR/src/game/envfx_snow.o(.data*);
      BUILD_DIR/src/game/envfx_bubbles.o(.data*);
      BUILD_DIR/src/game/macro_special_objects.o(.data*);
      BUILD_DIR/src/game/hud.o(.data*);
      BUILD_DIR/src/game/obj_behaviors.o(.data*);
      BUILD_DIR/src/game/obj_behaviors_2.o(.data*);
#ifndef VERSION_EU
      /* wildcard doesn't work on EU due to files being moved to engine/ */
      BUILD_DIR/src/game*.o(.data*);
#endif
      BUILD_DIR/src/audio/external.o(.data*);
      BUILD_DIR/src/audio/port_eu.o(.data*);
      BUILD_DIR/src/audio/data.o(.data*);
      BUILD_DIR/src/audio*.o(.data*);

#ifdef VERSION_EU

      lib/libultra_rom.a:_Printf.o(.data*);
      lib/libultra_rom.a:osInitialize.o(.data*);
      lib/libultra_rom.a:osCreateViManager.o(.data*);
      lib/libultra_rom.a:osViTable.o(.data*);
      lib/libultra_rom.a:osCreatePiManager.o(.data*);
      lib/libultra_rom.a:osContInit.o(.data*);
      lib/libultra_rom.a:osAiSetNextBuffer.o(.data*);

      lib/libultra_rom.a:_Litob.o(.data*);

      lib/libultra_rom.a:__osExceptionPreamble.o(.data*);

      lib/libultra_rom.a:osTimer.o(.data*);
      lib/libultra_rom.a:__osViInit.o(.data*);
      lib/libultra_rom.a:__osDequeueThread.o(.data*);  // ffff...

      lib/libultra_rom.a:__osPiCreateAccessQueue.o(.data*);
      lib/libultra_rom.a:__osSiCreateAccessQueue.o(.data*);
      lib/libultra_rom.a:osViData.o(.data*);

#else

      lib/libultra_rom.a:osViTable.o(.data*);
      lib/libultra_rom.a:osCreateViManager.o(.data*);
      lib/libultra_rom.a:osCreatePiManager.o(.data*);
      lib/libultra_rom.a:osInitialize.o(.data*);
      lib/libultra_rom.a:osContInit.o(.data*);
      lib/libultra_rom.a:osAiSetNextBuffer.o(.data*);
      lib/libultra_rom.a:osTimer.o(.data*);
      lib/libultra_rom.a:_Printf.o(.data*);
      lib/libultra_rom.a:__osDequeueThread.o(.data*);
      lib/libultra_rom.a:__osViInit.o(.data*);
      lib/libultra_rom.a:__osExceptionPreamble.o(.data*);
      lib/libultra_rom.a:__osPiCreateAccessQueue.o(.data*);
      lib/libultra_rom.a:__osSiCreateAccessQueue.o(.data*);
      lib/libultra_rom.a:_Litob.o(.data*);
      lib/libultra_rom.a:_Ldtob.o(.data*);
      lib/libultra_rom.a:osViData.o(.data*);
      lib/libultra_rom.a:kdebugserver.o(.data*);
      lib/libultra_rom.a:__osSyncPutChars.o(.data*);
      lib/libultra_rom.a:guRotateF.o(.data*);
      lib/libultra_rom.a:*.o(.data*);

#endif


      /* rodata */
      BUILD_DIR/src/game/crash_screen.o(.rodata*);
      BUILD_DIR/src/game/main.o(.rodata*);
      BUILD_DIR/src/game/game.o(.rodata*);
      BUILD_DIR/src/game/sound_init.o(.rodata*);
      BUILD_DIR/src/game/level_update.o(.rodata*);
      BUILD_DIR/src/game/interaction.o(.rodata*);
      BUILD_DIR/src/game/mario.o(.rodata*);
      BUILD_DIR/src/game/mario_step.o(.rodata*);
      BUILD_DIR/src/game/mario_actions_cutscene.o(.rodata*);
      BUILD_DIR/src/game/mario_actions_automatic.o(.rodata*);
      BUILD_DIR/src/game/mario_actions_stationary.o(.rodata*);
      BUILD_DIR/src/game/mario_actions_moving.o(.rodata*);
      BUILD_DIR/src/game/mario_actions_airborne.o(.rodata*);
      BUILD_DIR/src/game/mario_actions_submerged.o(.rodata*);
      BUILD_DIR/src/game/mario_actions_object.o(.rodata*);
      BUILD_DIR/src/game/mario_misc.o(.rodata*);
      BUILD_DIR/src/game/area.o(.rodata*);
      BUILD_DIR/src/game/rendering_graph_node.o(.rodata*);
      BUILD_DIR/src/game/camera.o(.rodata*);
      BUILD_DIR/src/game/object_list_processor.o(.rodata*);
#ifndef VERSION_EU
      BUILD_DIR/src/game/object_helpers.o(.rodata*);
#endif
      BUILD_DIR/src/game/behavior_actions.o(.rodata*);
#ifndef VERSION_EU
      BUILD_DIR/src/game/object_collision.o(.rodata*);
      BUILD_DIR/src/game/spawn_object.o(.rodata*);
#endif
      BUILD_DIR/src/game/spawn_sound.o(.rodata*);
      BUILD_DIR/src/game/debug.o(.rodata*);
      BUILD_DIR/src/game/screen_transition.o(.rodata*);
      BUILD_DIR/src/game/shadow.o(.rodata*);
      BUILD_DIR/src/game/skybox.o(.rodata*);
      BUILD_DIR/src/game/moving_texture.o(.rodata*);
      BUILD_DIR/src/game/geo_misc.o(.rodata*);
      BUILD_DIR/src/game/paintings.o(.rodata*);
      BUILD_DIR/src/game/print.o(.rodata*);
      BUILD_DIR/src/game/ingame_menu.o(.rodata*);
      BUILD_DIR/src/game/envfx_snow.o(.rodata*);
      BUILD_DIR/src/game/envfx_bubbles.o(.rodata*);
      BUILD_DIR/src/game/macro_special_objects.o(.rodata*);
      BUILD_DIR/src/game/hud.o(.rodata*);
      BUILD_DIR/src/game/obj_behaviors.o(.rodata*);
      BUILD_DIR/src/game/obj_behaviors_2.o(.rodata*);
#ifndef VERSION_EU
      BUILD_DIR/src/game*.o(.rodata*);
#endif
      BUILD_DIR/src/audio/synthesis.o(.rodata*);
      BUILD_DIR/src/audio/memory.o(.rodata*);
      BUILD_DIR/src/audio/load.o(.rodata*);
      BUILD_DIR/src/audio/playback.o(.rodata*);
      BUILD_DIR/src/audio/effects.o(.rodata*);
      BUILD_DIR/src/audio/seqplayer.o(.rodata*);
      BUILD_DIR/src/audio/external.o(.rodata*);
      BUILD_DIR/src/audio/port_eu.o(.rodata*);
      BUILD_DIR/src/audio*.o(.rodata*);

#ifdef VERSION_EU
      lib/libultra_rom.a:_Printf.o(.rodata*);

      lib/libultra_rom.a:guPerspectiveF.o(.rodata*);
      lib/libultra_rom.a:llconv.o(.rodata*);
      lib/libultra_rom.a:cosf.o(.rodata*);
      lib/libultra_rom.a:sinf.o(.rodata*);
      lib/libultra_rom.a:guRotateF.o(.rodata*);

      lib/libultra_rom.a:_Litob.o(.rodata*);
      lib/libultra_rom.a:_Ldtob.o(.rodata*);
      
      lib/libultra_rom.a:__osExceptionPreamble.o(.rodata*);
      lib/libultra_rom.a:__osDevMgrMain.o(.rodata*);
      
      lib/libultra_rom.a:NaN.o(.rodata*);
#else
      lib/libultra_rom.a:guPerspectiveF.o(.rodata*);
      lib/libultra_rom.a:llconv.o(.rodata*);
      lib/libultra_rom.a:cosf.o(.rodata*);
      lib/libultra_rom.a:sinf.o(.rodata*);
      lib/libultra_rom.a:guRotateF.o(.rodata*);
      lib/libultra_rom.a:_Printf.o(.rodata*);
      lib/libultra_rom.a:__osExceptionPreamble.o(.rodata*);
      lib/libultra_rom.a:NaN.o(.rodata*);
      lib/libultra_rom.a:_Litob.o(.rodata*);
      lib/libultra_rom.a:_Ldtob.o(.rodata*);
#endif
      lib/libultra_rom.a:osSetIntMask.o(.rodata*);
      lib/libultra_rom.a:guLookAtRef.o(.rodata*); /* Fast3DEX2 only */
#ifndef VERSION_EU
      lib/libultra_rom.a:*.o(.rodata*);
#endif
      BUILD_DIR/lib/rsp.o(.rodata*);
   }
   END_SEG(main)
   BEGIN_NOLOAD(main)
   {
      BUILD_DIR/src/game/crash_screen.o(.bss*);
      BUILD_DIR/src/game/main.o(.bss*);
      BUILD_DIR/src/game/game.o(.bss*);
      BUILD_DIR/src/game/sound_init.o(.bss*);
      BUILD_DIR/src/game/level_update.o(.bss*);
      BUILD_DIR/src/game/interaction.o(.bss*);
      BUILD_DIR/src/game/mario.o(.bss*);
      BUILD_DIR/src/game/mario_actions_cutscene.o(.bss*);
      BUILD_DIR/src/game/mario_actions_moving.o(.bss*);
      BUILD_DIR/src/game/mario_actions_submerged.o(.bss*);
      BUILD_DIR/src/game/mario_misc.o(.bss*);
      BUILD_DIR/src/game/memory.o(.bss*);
      BUILD_DIR/src/game/save_file.o(.bss*);
      BUILD_DIR/src/game/area.o(.bss*);
      BUILD_DIR/src/game/rendering_graph_node.o(.bss*);
      BUILD_DIR/src/game/profiler.o(.bss*);
      BUILD_DIR/src/game/camera.o(.bss*);
      BUILD_DIR/src/game/object_list_processor.o(.bss*);
#ifndef VERSION_EU
      BUILD_DIR/src/game/object_helpers.o(.bss*);
#endif
      BUILD_DIR/src/game/behavior_actions.o(.bss*);
      BUILD_DIR/src/game/debug.o(.bss*);
      BUILD_DIR/src/game/shadow.o(.bss*);
      BUILD_DIR/src/game/skybox.o(.bss*);
      BUILD_DIR/src/game/moving_texture.o(.bss*);
      BUILD_DIR/src/game/geo_misc.o(.bss*);
      BUILD_DIR/src/game/paintings.o(.bss*);
      BUILD_DIR/src/game/print.o(.bss*);
      BUILD_DIR/src/game/ingame_menu.o(.bss*);
      BUILD_DIR/src/game/envfx_snow.o(.bss*);
      BUILD_DIR/src/game/envfx_bubbles.o(.bss*);
      BUILD_DIR/src/game/macro_special_objects.o(.bss*)
      BUILD_DIR/src/game/hud.o(.bss*);
      BUILD_DIR/src/game/obj_behaviors.o(.bss*);
      BUILD_DIR/src/game/obj_behaviors_2.o(.bss*);
#ifndef VERSION_EU
      BUILD_DIR/src/game*.o(.bss*);
#endif
      BUILD_DIR/src/audio/external.o(.bss*);
      BUILD_DIR/src/audio/port_eu.o(.bss*);
   
#ifdef VERSION_EU
      lib/libultra_rom.a:osInitialize.o(.bss*);

      lib/libultra_rom.a:osSetEventMesg.o(.bss*);
      lib/libultra_rom.a:osSpTaskLoadGo.o(.bss*);
      lib/libultra_rom.a:osCreateViManager.o(.bss*);
      
      lib/libultra_rom.a:osCreatePiManager.o(.bss*);
      lib/libultra_rom.a:osContStartReadData.o(.bss*);
      lib/libultra_rom.a:osContInit.o(.bss*);

      lib/libultra_rom.a:guRotateF.o(.bss*);

      lib/libultra_rom.a:unk_stack_data.o(.bss*);
      lib/libultra_rom.a:osTimer.o(.bss*);
      lib/libultra_rom.a:__osPiCreateAccessQueue.o(.bss*);
      lib/libultra_rom.a:__osSiCreateAccessQueue.o(.bss*);
      lib/libultra_rom.a:osEepromWrite.o(.bss*);
      
      lib/libultra_rom.a:kdebugserver.o(.bss*);
      lib/libultra_rom.a:osLeoDiskInit.o(.bss*)

      lib/libultra_rom.a:_Printf.o(.bss*);
      lib/libultra_rom.a:osAiSetNextBuffer.o(.bss*);
      lib/libultra_rom.a:EU_D_802f4330.o(.bss*);

#else
      lib/libultra_rom.a:osSetEventMesg.o(.bss*);
      lib/libultra_rom.a:osSpTaskLoadGo.o(.bss*);
      lib/libultra_rom.a:osCreateViManager.o(.bss*);
      lib/libultra_rom.a:osCreatePiManager.o(.bss*);
      lib/libultra_rom.a:osInitialize.o(.bss*);
      lib/libultra_rom.a:osContStartReadData.o(.bss*);
      lib/libultra_rom.a:osContInit.o(.bss*);
      lib/libultra_rom.a:guRotateF.o(.bss*);
      lib/libultra_rom.a:osTimer.o(.bss*);
      lib/libultra_rom.a:_Printf.o(.bss*);
      lib/libultra_rom.a:__osPiCreateAccessQueue.o(.bss*);
      lib/libultra_rom.a:__osSiCreateAccessQueue.o(.bss*);
      lib/libultra_rom.a:osEepromWrite.o(.bss*);
      lib/libultra_rom.a:unk_stack_data.o(.bss*);
      lib/libultra_rom.a:kdebugserver.o(.bss*);
      lib/libultra_rom.a:*.o(.bss*);
#endif
   }
   END_NOLOAD(main)
   _mainSegmentNoloadSizeLo = SIZEOF (.main.noload) & 0xffff;
   _mainSegmentNoloadSizeHi = SIZEOF (.main.noload) >> 16;

   ASSERT((. <= SEG_ENGINE), "Error: main segment extended into engine.")

   BEGIN_SEG(engine, SEG_ENGINE)
   {
      BUILD_DIR/src/engine/math_util.o(.text);
      BUILD_DIR/src/engine/graph_node.o(.text);
      BUILD_DIR/src/engine/graph_node_manager.o(.text);
      BUILD_DIR/src/engine/geo_layout.o(.text);
      BUILD_DIR/src/engine/level_script.o(.text);
      BUILD_DIR/src/engine/surface_collision.o(.text);
      BUILD_DIR/src/engine/surface_load.o(.text);
      BUILD_DIR/src/engine/behavior_script.o(.text);
#ifdef VERSION_EU
      BUILD_DIR/src/game/object_collision.o(.text);
      BUILD_DIR/src/game/spawn_object.o(.text);
      BUILD_DIR/src/game/object_helpers.o(.text);
#endif
      BUILD_DIR/src/engine*.o(.text);
      /* data */
      BUILD_DIR/src/engine/graph_node.o(.data*);
      BUILD_DIR/src/engine/graph_node_manager.o(.data*);
      BUILD_DIR/src/engine/math_util.o(.data*);
      BUILD_DIR/src/engine/geo_layout.o(.data*);
      BUILD_DIR/src/engine/level_script.o(.data*);
      BUILD_DIR/src/engine/behavior_script.o(.data*);
#ifdef VERSION_EU
      BUILD_DIR/src/game/object_collision.o(.data*);
      BUILD_DIR/src/game/spawn_object.o(.data*);
      BUILD_DIR/src/game/object_helpers.o(.data*);
#endif
      BUILD_DIR/src/engine*.o(.data*);
      /* rodata */
      BUILD_DIR/src/engine/math_util.o(.rodata*);
      BUILD_DIR/src/engine/level_script.o(.rodata*);
      BUILD_DIR/src/engine/surface_collision.o(.rodata*);
      BUILD_DIR/src/engine/surface_load.o(.rodata*);
#ifdef VERSION_EU
      BUILD_DIR/src/game/object_collision.o(.rodata*);
      BUILD_DIR/src/game/spawn_object.o(.rodata*);
      BUILD_DIR/src/game/object_helpers.o(.rodata*);
#endif
      BUILD_DIR/src/engine*.o(.rodata*);
   }
   END_SEG(engine)
   BEGIN_NOLOAD(engine)
   {
      BUILD_DIR/src/engine/math_util.o(.bss*);
      BUILD_DIR/src/engine/geo_layout.o(.bss*);
      BUILD_DIR/src/engine/level_script.o(.bss*);
      BUILD_DIR/src/engine/surface_collision.o(.bss*);
      BUILD_DIR/src/engine/surface_load.o(.bss*);
      BUILD_DIR/src/engine/behavior_script.o(.bss*);
#ifdef VERSION_EU
      BUILD_DIR/src/game/object_collision.o(.bss*);
      BUILD_DIR/src/game/spawn_object.o(.bss*);
      BUILD_DIR/src/game/object_helpers.o(.bss*);
#endif
      BUILD_DIR/src/engine*.o(.bss*);
   }
   END_NOLOAD(engine)

   // ASSERT((. <= SEG_FRAMEBUFFERS), "Error: engine segment extended into framebuffers.")

   . = SEG_FRAMEBUFFERS;
   BEGIN_NOLOAD(framebuffers)
   {
      BUILD_DIR/src/buffers/framebuffers.o(.bss*);
   }
   END_NOLOAD(framebuffers)

   __expansionRamStart = 0x80400000;
   ASSERT((. <= __expansionRamStart), "Error: RDRAM expanded into Expansion RAM, despite Expansion RAM not being defined.")


   BEGIN_SEG(entry, 0x10000000)
   {
      BUILD_DIR/levels/entry.o(.data);
   }
   END_SEG(entry)

   /* load MIO0 and level data */
   MIO0_SEG(segment2, 0x02000000)
#ifdef VERSION_EU
   MIO0_EU_SEG(translation_en, 0x19000000)
   MIO0_EU_SEG(translation_fr, 0x19000000)
   MIO0_EU_SEG(translation_de, 0x19000000)
#endif

   /* mario actor group */
   STANDARD_OBJECTS(group0,  0x04000000, 0x17000000)

   /* load the other actor groups */
   STANDARD_OBJECTS(group1,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group2,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group3,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group4,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group5,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group6,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group7,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group8,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group9,  0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group10, 0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group11, 0x05000000, 0x0C000000)
   STANDARD_OBJECTS(group12, 0x06000000, 0x0D000000)
   STANDARD_OBJECTS(group13, 0x06000000, 0x0D000000)
   STANDARD_OBJECTS(group14, 0x06000000, 0x0D000000)
   STANDARD_OBJECTS(group15, 0x06000000, 0x0D000000)
   STANDARD_OBJECTS(group16, 0x06000000, 0x0D000000)
   STANDARD_OBJECTS(group17, 0x06000000, 0x0D000000)

   /* load the common actor groups */
   STANDARD_OBJECTS(common0, 0x08000000, 0x0F000000)
   STANDARD_OBJECTS(common1, 0x03000000, 0x16000000)

   /* use segmented addressing for behaviors */
   BEGIN_SEG(behavior, 0x13000000)
   {
      BUILD_DIR/data/behavior_data.o(.data);
   }
   END_SEG(behavior)

   /* 0x8016F000 21D7D0-255EC0 [386F0] */
   BEGIN_SEG(goddard, SEG_GODDARD)
   {
      BUILD_DIR/src/menu/level_select_menu.o(.text);
      BUILD_DIR/src/menu/intro_geo.o(.text);
      BUILD_DIR/src/menu/file_select.o(.text);
      BUILD_DIR/src/menu/star_select.o(.text);
      BUILD_DIR/src/menu*.o(.text);
      BUILD_DIR/libgoddard.a:gd_main.o(.text);
      BUILD_DIR/libgoddard.a:gd_memory.o(.text);
      BUILD_DIR/libgoddard.a:sfx.o(.text);
      BUILD_DIR/libgoddard.a:draw_objects.o(.text);
      BUILD_DIR/libgoddard.a:objects.o(.text);
      BUILD_DIR/libgoddard.a:skin_movement.o(.text);
      BUILD_DIR/libgoddard.a:particles.o(.text);
      BUILD_DIR/libgoddard.a:dynlist_proc.o(.text);
      BUILD_DIR/libgoddard.a:old_menu.o(.text);
      BUILD_DIR/libgoddard.a:debug_utils.o(.text);
      BUILD_DIR/libgoddard.a:joints.o(.text);
      BUILD_DIR/libgoddard.a:skin.o(.text);
      BUILD_DIR/libgoddard.a:gd_math.o(.text);
      BUILD_DIR/libgoddard.a:shape_helper.o(.text);
      BUILD_DIR/libgoddard.a:renderer.o(.text);
      BUILD_DIR/libgoddard.a:*.o(.text);
      /* data, rodata, per file */
      BUILD_DIR/src/menu/level_select_menu.o(.data*);
      BUILD_DIR/src/menu/level_select_menu.o(.rodata*);
      BUILD_DIR/src/menu/intro_geo.o(.data*);
      BUILD_DIR/src/menu/file_select.o(.data*);
      BUILD_DIR/src/menu/file_select.o(.rodata*);
      BUILD_DIR/src/menu/star_select.o(.data*);
      BUILD_DIR/src/menu/star_select.o(.rodata*);
      BUILD_DIR/src/menu*.o(.data*);
      BUILD_DIR/src/menu*.o(.rodata*);
      /* goddard subsystem data */
      BUILD_DIR/libgoddard.a:gd_main.o(.data*);
      BUILD_DIR/libgoddard.a:draw_objects.o(.data*);
      BUILD_DIR/libgoddard.a:objects.o(.data*);
      BUILD_DIR/libgoddard.a:particles.o(.data*);
      BUILD_DIR/libgoddard.a:dynlist_proc.o(.data*);
      BUILD_DIR/libgoddard.a:debug_utils.o(.data*);
      BUILD_DIR/libgoddard.a:joints.o(.data*);
      BUILD_DIR/libgoddard.a:shape_helper.o(.data*);
      BUILD_DIR/libgoddard.a:renderer.o(.data*);
      /* goddard subsystem rodata */
      BUILD_DIR/libgoddard.a:gd_main.o(.rodata*);
      BUILD_DIR/libgoddard.a:gd_memory.o(.rodata*);
      BUILD_DIR/libgoddard.a:draw_objects.o(.rodata*);
      BUILD_DIR/libgoddard.a:objects.o(.rodata*);
      BUILD_DIR/libgoddard.a:skin_movement.o(.rodata*);
      BUILD_DIR/libgoddard.a:particles.o(.rodata*);
      BUILD_DIR/libgoddard.a:dynlist_proc.o(.rodata*);
      BUILD_DIR/libgoddard.a:old_menu.o(.rodata*);
      BUILD_DIR/libgoddard.a:debug_utils.o(.rodata*);
      BUILD_DIR/libgoddard.a:joints.o(.rodata*);
      BUILD_DIR/libgoddard.a:skin.o(.rodata*);
      BUILD_DIR/libgoddard.a:gd_math.o(.rodata*);
      BUILD_DIR/libgoddard.a:shape_helper.o(.rodata*);
      BUILD_DIR/libgoddard.a:renderer.o(.rodata*);
   }
   END_SEG(goddard)
   BEGIN_NOLOAD(goddard)
   {
      BUILD_DIR/src/menu/intro_geo.o(.bss*);
      BUILD_DIR/src/menu/file_select.o(.bss*);
      BUILD_DIR/src/menu/star_select.o(.bss*);
      BUILD_DIR/src/menu*.o(.bss*);
      BUILD_DIR/libgoddard.a:gd_main.o(.bss*);
      BUILD_DIR/libgoddard.a:gd_memory.o(.bss*);
      BUILD_DIR/libgoddard.a:sfx.o(.bss*);
      BUILD_DIR/libgoddard.a:draw_objects.o(.bss*);
      BUILD_DIR/libgoddard.a:objects.o(.bss*);
      BUILD_DIR/libgoddard.a:skin_movement.o(.bss*);
      BUILD_DIR/libgoddard.a:particles.o(.bss*);
      BUILD_DIR/libgoddard.a:dynlist_proc.o(.bss*);
      BUILD_DIR/libgoddard.a:old_menu.o(.bss*);
      BUILD_DIR/libgoddard.a:debug_utils.o(.bss*);
      BUILD_DIR/libgoddard.a:joints.o(.bss*);
      BUILD_DIR/libgoddard.a:skin.o(.bss*);
      BUILD_DIR/libgoddard.a:shape_helper.o(.bss*);
      BUILD_DIR/libgoddard.a:renderer.o(.bss*);
      BUILD_DIR/libgoddard.a:*.o(.bss*);
   }
   END_NOLOAD(goddard)

   ASSERT((. <= SEG_POOL_END), "Error: extended past pool end.")

   . = SEG_BUFFERS;
   BEGIN_NOLOAD(buffers)
   {
      BUILD_DIR/src/buffers/buffers.o(.bss*);
      BUILD_DIR/src/audio/globals_start.o(.bss*);

      BUILD_DIR/src/audio/synthesis.o(.bss*);
      BUILD_DIR/src/audio/memory.o(.bss*);
      BUILD_DIR/src/audio/load.o(.bss*);
      BUILD_DIR/src/audio/data.o(.bss*);
      BUILD_DIR/src/audio/globals_end.o(.bss*);
#ifdef VERSION_EU
      . += 0x4f0;
#endif
      
#ifndef VERSION_EU
      . = ALIGN(0x1000);
#endif
      BUILD_DIR/src/buffers/gfx_output_buffer.o(.bss*);

      BUILD_DIR/src/audio*.o(.bss*);
   }
   END_NOLOAD(buffers)

   /* While EU is being worked on, don't warn for a too large buffers segment.
    * This is a broken thing to do, so please enforce this again when it's fixed! */
#ifndef VERSION_EU
   ASSERT((. <= SEG_MAIN), "Error: buffers segment extended into main.")
#endif

   /* 0x268020 0x268020-0 [0] */
   BEGIN_SEG(intro, 0x14000000)
   {
      BUILD_DIR/levels/intro/script.o(.data);
      BUILD_DIR/levels/intro/geo.o(.data);
   }
   END_SEG(intro)
   BEGIN_SEG(intro_segment_7, 0x07000000)
   {
      BUILD_DIR/levels/intro/leveldata.mio0.o(.data);
      . = ALIGN(0x10);
   }
   END_SEG(intro_segment_7)

   MIO0_SEG(debug_level_select, 0x07000000)
   MIO0_SEG(title_screen_bg, 0x0A000000)

   /* 271B20-2A42A0 [32780] */
   BEGIN_SEG(gd_dynlists, 0x04000000)
   {
      BUILD_DIR/libgoddard.a:dynlist_test_cube.o(.data);
      BUILD_DIR/libgoddard.a:dynlist_unused.o(.data);
      BUILD_DIR/libgoddard.a:dynlist_mario_face.o(.data);
      BUILD_DIR/libgoddard.a:dynlists_mario_eyes.o(.data);
      BUILD_DIR/libgoddard.a:dynlists_mario_eyebrows_mustache.o(.data);
      BUILD_DIR/libgoddard.a:dynlist_mario_master.o(.data);
      BUILD_DIR/libgoddard.a:anim_mario_mustache_right.o(.data);
      BUILD_DIR/libgoddard.a:anim_mario_mustache_left.o(.data);
      BUILD_DIR/libgoddard.a:anim_mario_lips_1.o(.data);
      BUILD_DIR/libgoddard.a:anim_mario_lips_2.o(.data);
      BUILD_DIR/libgoddard.a:anim_mario_eyebrows_1.o(.data);
      BUILD_DIR/libgoddard.a:anim_group_1.o(.data);
      BUILD_DIR/libgoddard.a:anim_group_2.o(.data);
      BUILD_DIR/libgoddard.a:dynlist_test_cube.o(.rodata);
      BUILD_DIR/libgoddard.a:dynlist_unused.o(.rodata);
      BUILD_DIR/libgoddard.a:*.o(.data);
      BUILD_DIR/libgoddard.a:*.o(.rodata);
   }
   END_SEG(gd_dynlists)

   gMainLevels = __romPos;

   BEGIN_SEG(menu, 0x14000000)
   {
      BUILD_DIR/levels/menu/script.o(.data);
      BUILD_DIR/levels/menu/geo.o(.data);
   }
   END_SEG(menu)
   BEGIN_SEG(menu_segment_7, 0x07000000)
   {
      BUILD_DIR/levels/menu/leveldata.mio0.o(.data);
      . = ALIGN(0x10);
   }
   END_SEG(menu_segment_7)

   BEGIN_SEG(scripts, 0x15000000)
   {
      BUILD_DIR/levels/scripts.o(.data);
   }
   END_SEG(scripts)

   MIO0_SEG(water_skybox, 0x0A000000)
   MIO0_SEG(ccm_skybox, 0x0A000000)
   MIO0_SEG(clouds_skybox, 0x0A000000)
   MIO0_SEG(bitfs_skybox, 0x0A000000)
   MIO0_SEG(wdw_skybox, 0x0A000000)
   MIO0_SEG(cloud_floor_skybox, 0x0A000000)
   MIO0_SEG(ssl_skybox, 0x0A000000)
   MIO0_SEG(bbh_skybox, 0x0A000000)
   MIO0_SEG(bidw_skybox, 0x0A000000)
   MIO0_SEG(bits_skybox, 0x0A000000)

   // Texture bins
   MIO0_SEG(fire, 0x09000000)
   MIO0_SEG(spooky, 0x09000000)
   MIO0_SEG(generic, 0x09000000)
   MIO0_SEG(water, 0x09000000)
   MIO0_SEG(sky, 0x09000000)
   MIO0_SEG(snow, 0x09000000)
   MIO0_SEG(cave, 0x09000000)
   MIO0_SEG(machine, 0x09000000)
   MIO0_SEG(mountain, 0x09000000)
   MIO0_SEG(grass, 0x09000000)
   MIO0_SEG(outside, 0x09000000)
   MIO0_SEG(inside, 0x09000000)
   MIO0_SEG(effect, 0x0B000000)

#define STUB_LEVEL(_0, _1, _2, _3, _4, _5, _6, _7, _8)
#define DEFINE_LEVEL(_0, _1, _2, folder, _4, _5, _6, _7, _8, _9, _10) STANDARD_LEVEL(folder)

   #include "levels/level_defines.h"

#undef STUB_LEVEL
#undef DEFINE_LEVEL

   /* 4E9FA0-? [?] */
   BEGIN_SEG(assets, __romPos)
   {
      BUILD_DIR/assets/mario_anim_data.o(.data);
      BUILD_DIR/assets/demo_data.o(.data);
      gSoundDataADSR = .;
      BUILD_DIR/sound/sound_data.ctl.o(.data);
      gSoundDataRaw = .;
      BUILD_DIR/sound/sound_data.tbl.o(.data);
      gMusicData = .;
      BUILD_DIR/sound/sequences.bin.o(.data);
      gBankSetsData = .;
      BUILD_DIR/sound/bank_sets.o(.data);
   }
   END_SEG(assets)

   /* Discard everything not specifically mentioned above. */
   /DISCARD/ :
   {
      *(*);
   }
}
