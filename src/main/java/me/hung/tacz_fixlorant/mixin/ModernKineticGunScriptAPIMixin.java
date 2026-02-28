package me.hung.tacz_fixlorant.mixin;
import com.tacz.guns.item.ModernKineticGunScriptAPI;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.Pose;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.Unique;


@Mixin(ModernKineticGunScriptAPI.class)
public abstract class ModernKineticGunScriptAPIMixin {

    @Shadow private LivingEntity shooter;

    /**
     * Lua-callable: api:isCrouching()
     */
    @Unique
    public boolean isCrouching() {
        // Prefer "isCrouching" if available; in 1.20.1 this usually maps fine in Java.
        return shooter != null && shooter.isCrouching();
    }

    /**
     * Lua-callable: api:isSprinting()
     */
    @Unique
    public boolean isSprinting() {
        return shooter != null && shooter.isSprinting();
    }

    @Unique
    public double getThePlayerMovement() {
        double dx = shooter.getX() - shooter.xOld;
        double dz = shooter.getZ() - shooter.zOld;
        return (dx * dx + dz * dz);
    }

    @Unique
    public boolean isMoving() {
        double dx = shooter.getX() - shooter.xOld;
        double dz = shooter.getZ() - shooter.zOld;
        return (dx * dx + dz * dz > 0.0004);
    }

    /**
     * Lua-callable: api:isCrawling()
     * Vanilla has no formal "crawl", so we infer using pose.
     * Many "crawl on land" implementations use SWIMMING pose without being in water.
     */
    @Unique
    public boolean isCrawling() {
        if (shooter == null) return false;

        Pose pose = shooter.getPose();
        boolean swimPose = pose == Pose.SWIMMING;

        // "Crawling on land" heuristic:
        boolean inWater = shooter.isInWater();
        return swimPose && !inWater;
    }

    @Unique
    public boolean isOnGround() {
        return shooter != null && shooter.onGround();
    }
}