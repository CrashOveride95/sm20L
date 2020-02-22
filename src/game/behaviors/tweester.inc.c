/**
 * Behavior file for bhvTweester and bhvTweesterSandParticle
 * Tweester swaps between twhree action- an idle action, a chasing
 * Mario action, and an action that hides it. At certain times the
 * Tweester spawns the sand particles also in this file.
 */

struct ObjectHitbox sTweesterHitbox = {
    /* interactType:      */ INTERACT_TORNADO,
    /* downOffset:        */ 0,
    /* damageOrCoinValue: */ 0,
    /* health:            */ 0,
    /* numLootCoins:      */ 0,
    /* radius:            */ 1500,
    /* height:            */ 4000,
    /* hurtboxRadius:     */ 0,
    /* hurtboxHeight:     */ 0,
};

/**
 * Controls the scaling of the tweester as well as
 * its forward velocity.
 */
void tweester_scale_and_move(f32 preScale) {
    s16 dYaw  = 0x2C00;
    f32 scale = preScale * 0.4;

    o->header.gfx.scale[0] 
        = (( coss(o->oTweesterScaleTimer) + 1.0) * 0.5 * 0.3 + 1.0) * scale;
    o->header.gfx.scale[1] 
        = ((-coss(o->oTweesterScaleTimer) + 1.0) * 0.5 * 0.5 + 0.5) * scale;
    o->header.gfx.scale[2] 
        = (( coss(o->oTweesterScaleTimer) + 1.0) * 0.5 * 0.3 + 1.0) * scale;

    o->oTweesterScaleTimer += 0x200;
    o->oForwardVel = 14.0f;
    o->oFaceAngleYaw += dYaw;
}

/**
 * Tweester's idle action. Basically stays in active until Mario enters a 1500
 * radius, at which point it appears and grows for 60 frames at which point it
 * it enters the chasing action.
 */
void tweester_act_idle(void) {
    if (o->oSubAction == TWEESTER_SUB_ACT_WAIT) {
        obj_become_tangible();
        obj_set_pos_to_home();
        obj_scale(0);

        // Hard to have any idea of this purpose, only set here.
        o->oTweesterUnused = 0;

        // If Mario is within range, change to the growth sub-action.
        if (o->oDistanceToMario < 1500.0f)
            o->oSubAction++;

        o->oTimer = 0;
    } else {
        PlaySound(SOUND_ENV_WIND1);
        tweester_scale_and_move(o->oTimer / 60.0f);
        if (o->oTimer > 59)
            o->oAction = TWEESTER_ACT_CHASE;
    }
}

/**
 * Action where the tweester "chases" Mario.
 * After Mario is twirling, then return home.
 */
void tweester_act_chase(void) {
    f32 activationRadius = o->oBehParams2ndByte * 100;

    o->oAngleToHome = obj_angle_to_home();
    PlaySound(SOUND_ENV_WIND1);

    if (obj_lateral_dist_from_mario_to_home() < activationRadius
        && o->oSubAction == TWEESTER_SUB_ACT_CHASE) {

        o->oForwardVel = 20.0f;
        obj_rotate_yaw_toward(o->oAngleToMario, 0x200);
        print_debug_top_down_objectinfo("off ", 0);

        if (gMarioStates->action == ACT_TWIRLING)
            o->oSubAction++;
    } else {
        o->oForwardVel = 20.0f;
        obj_rotate_yaw_toward(o->oAngleToHome, 0x200);

        if (obj_lateral_dist_to_home() < 200.0f)
            o->oAction = TWEESTER_ACT_HIDE;
    }

    if (o->oDistanceToMario > 3000.0f)
        o->oAction = TWEESTER_ACT_HIDE;

    obj_update_floor_and_walls();
    if (o->oMoveFlags & OBJ_MOVE_HIT_WALL)
        o->oMoveAngleYaw = o->oWallAngle;

    obj_move_standard(60);
    tweester_scale_and_move(1.0f);
    spawn_object(o, MODEL_SAND_DUST, bhvTweesterSandParticle);
}

/**
 * Shrinks the tweester until it is invisible, then returns to the idle
 * action if Mario is 2500 units away or 12 seconds passed.
 */
void tweester_act_hide(void) {
    f32 shrinkTimer = 60.0f - o->oTimer;

    if (shrinkTimer >= 0.0f)
        tweester_scale_and_move(shrinkTimer / 60.0f);
    else {
        obj_become_intangible();
        if (obj_lateral_dist_from_mario_to_home() > 2500.0f)
            o->oAction = TWEESTER_ACT_IDLE;
        if (o->oTimer > 360)
            o->oAction = TWEESTER_ACT_IDLE;
    }
}

// Array of Tweester action functions.
void (*sTweesterActions[])(void) = { tweester_act_idle, tweester_act_chase, tweester_act_hide };

/**
 * Loop behavior for Tweester. 
 * Loads the hitbox and calls its relevant action.
 */
void bhv_tweester_loop(void) {
    set_object_hitbox(o, &sTweesterHitbox);
    obj_call_action_function(sTweesterActions);
    o->oInteractStatus = 0;
}

/**
 * Loop behavior for the particles Tweesters create.
 * Floats upwards semi-randomly.
 */
void bhv_tweester_sand_particle_loop(void) {
    o->oMoveAngleYaw += 0x3700;
    o->oForwardVel += 15.0f;
    o->oPosY += 22.0f;

    obj_scale(RandomFloat() + 1.0);

    if (o->oTimer == 0) {
        translate_object_xz_random(o, 100.0f);
        o->oFaceAnglePitch = RandomU16();
        o->oFaceAngleYaw = RandomU16();
    }

    if (o->oTimer > 15)
        mark_object_for_deletion(o);
}