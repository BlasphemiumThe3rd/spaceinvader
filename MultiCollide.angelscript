#include "Collide.angelscript"

bool Collide(ETHEntity@ entity, ETHEntityArray@ collidingEntities, EntityChooser@ chooser = ___defaultChooser)
{
	if (!entity.Collidable())
	{
		return false;
	}

	ETHEntityArray entities;
	GetEntitiesAroundEntity(entity, entities);

	bool r = false;

	const uint size = entities.size();
	for (uint t = 0; t < size; t++)
	{
		ETHEntity@ other = @(entities[t]);
		if (other.Collidable() && entity.GetID() != other.GetID() && chooser.choose(other))
		{
			if (collide(getAbsoluteCollisionBox(entity), getAbsoluteCollisionBox(other)))
			{
				collidingEntities.Insert(other);
				r = true;
			}
		}
	}
	return r;
}
