//=============================================================================
// VG_PlayerPawn
//
// Pawn which represents the player. Handles visual components and driving
// the aim offset.
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class VG_PlayerPawn extends Pawn;

// Dynamic light environment component to help speed up lighting calculations for the pawn
var(Pawn) const DynamicLightEnvironmentComponent LightEnvironment;
// How fast a pawn turns
var(Pawn) const float TurnRate;
// How high the pawn jumps
var(Pawn) const float JumpHeight;
// Socket to use for attaching weapons
var(Pawn) const Name WeaponSocketName;
// Height to set the collision cylinder when crouching
var(Pawn) const float CrouchHeightOverride<DisplayName=Crouch Height>;
// Radius to set the collision cylinder when crouching
var(Pawn) const float CrouchRadiusOverride<DisplayName=Crouch Radius>;

// Reference to the aim node aim offset node
var AnimNodeAimOffset AimNode;
// Reference to the gun recoil skel controller node
var GameSkelCtrl_Recoil GunRecoilNode;
// Internal int which stores the desired yaw of the pawn
var int DesiredYaw;
// Internal int which store the current yaw of the pawn
var int CurrentYaw;
// Internal int which stores the current pitch of the pawn
var int CurrentPitch;

/**
 * Constructor which always gets called when the pawn is spawned. Just sets the value of the desired yaw and
 * current yaw to the rotation yaw when first spawned
 *
 * @network				Server and client
 */
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Set the desired and current yaw to the same as what the pawn spawned in
	DesiredYaw = Rotation.Yaw;
	CurrentYaw = Rotation.Yaw;

	// Set the crouch height and radius overrides
	CrouchHeight = CrouchHeightOverride;
	CrouchRadius = CrouchRadiusOverride;
}

/**
 * Destructor which always gets called when the pawn is destroyed. This is useful for cleaning up any
 * object reference we may have
 *
 * @network				Server and client
 */
simulated event Destroyed()
{
	Super.Destroyed();

	AimNode = None;
	GunRecoilNode = None;
}

/**
 * Called when the actor has finished initializing a skeletal mesh component's anim tree. This is usually a good
 * place to start grabbing anim nodes or skeletal controllers
 *
 * @param	SkelComp	Skeletal mesh component that has had its anim tree initialized.
 * @network				Server and client
 */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	if (SkelComp == Mesh)
	{
		// Find the aim offset node
		AimNode = AnimNodeAimOffset(Mesh.FindAnimNode('AimNode'));
		// Find the gun recoil skeletal control node
		GunRecoilNode = GameSkelCtrl_Recoil(Mesh.FindSkelControl('GunRecoilNode'));
	}
}

/**
 * Adjusts weapon aiming direction.
 * Gives Pawn a chance to modify its aiming. For example aim error, auto aiming, adhesion, AI help...
 * Requested by weapon prior to firing.
 *
 * @param	W				Weapon about to fire
 * @param	StartFireLoc	World location of weapon fire start trace, or projectile spawn loc.
 * @return					Rotation to fire from
 * @network					Server and client
 */
simulated function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
	local Vector SocketLocation;
	local Rotator SocketRotation;
	local VG_Weapon VG_Weapon;
	local SkeletalMeshComponent WeaponSkeletalMeshComponent;

	VG_Weapon = VG_Weapon(Weapon);
	if (VG_Weapon != None)
	{
		WeaponSkeletalMeshComponent = SkeletalMeshComponent(VG_Weapon.Mesh);
		if (WeaponSkeletalMeshComponent != None && WeaponSkeletalMeshComponent.GetSocketByName(VG_Weapon.MuzzleSocketName) != None)
		{			
			WeaponSkeletalMeshComponent.GetSocketWorldLocationAndRotation(VG_Weapon.MuzzleSocketName, SocketLocation, SocketRotation);
			return SocketRotation;
		}
	}

	return Rotation;
}

/**
 * Return world location to start a weapon fire trace from.
 *
 * @param	CurrentWeapon		Weapon about to fire
 * @return						World location where to start weapon fire traces from
 * @network						Server and client
 */
simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	local Vector SocketLocation;
	local Rotator SocketRotation;
	local VG_Weapon VG_Weapon;
	local SkeletalMeshComponent WeaponSkeletalMeshComponent;

	VG_Weapon = VG_Weapon(Weapon);
	if (VG_Weapon != None)
	{
		WeaponSkeletalMeshComponent = SkeletalMeshComponent(VG_Weapon.Mesh);
		if (WeaponSkeletalMeshComponent != None && WeaponSkeletalMeshComponent.GetSocketByName(VG_Weapon.MuzzleSocketName) != None)
		{
			WeaponSkeletalMeshComponent.GetSocketWorldLocationAndRotation(VG_Weapon.MuzzleSocketName, SocketLocation, SocketRotation);
			return SocketLocation;
		}
	}

	return Super.GetWeaponStartTraceLocation(CurrentWeapon);
}



/**
 * Appends to the Z velocity when the pawn wants to jump.
 *
 * @param	bUpdating	True if updating
 * @network			Server
 */
function bool DoJump(bool bUpdating)
{
	if (bJumpCapable && !bIsCrouched && !bWantsToCrouch && (Physics == PHYS_Walking || Physics == PHYS_Ladder || Physics == PHYS_Spider))
 	{
		if (Physics == PHYS_Spider)
		{
			Velocity = JumpHeight * Floor;
		}
		else if (Physics == PHYS_Ladder)
		{
			Velocity.Z = 0.f;
		}
		else
		{
			Velocity.Z = JumpHeight;
		}

		if (Base != None && !Base.bWorldGeometry && Base.Velocity.Z > 0.f)
		{
			Velocity.Z += Base.Velocity.Z;
		}

		SetPhysics(PHYS_Falling);
		return true;
	}

	return false;
}

defaultproperties
{
	// Remove the sprite component as it is not needed
	Components.Remove(Sprite)

	// Create a light environment for the pawn
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bSynthesizeSHLight=true
		bIsCharacterLightEnvironment=true
		bUseBooleanEnvironmentShadowing=false
	End Object
	Components.Add(MyLightEnvironment)
	LightEnvironment=MyLightEnvironment

	// Create a skeletal mesh component for the pawn
	Begin Object Class=SkeletalMeshComponent Name=MySkeletalMeshComponent
		bCacheAnimSequenceNodes=false
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=true
		BlockRigidBody=true
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=false
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2f
		bChartDistanceFactor=true
		RBDominanceGroup=20
		Scale=1.f
		bAllowAmbientOcclusion=false
		bUseOnePassLightingOnTranslucency=true
		bPerBoneMotionBlur=true
	End Object
	Mesh=MySkeletalMeshComponent
	Components.Add(MySkeletalMeshComponent)
	
	InventoryManagerClass=class'VG_InventoryManager'
	JumpHeight=420.f
	bCanCrouch=true
	bCanPickupInventory=true
}