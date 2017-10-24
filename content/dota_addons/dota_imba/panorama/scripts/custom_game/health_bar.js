function Bar(parent){
    this.element = $.CreatePanel("Panel", parent, "");
    this.element.AddClass("HealthBar");

    this.SetAlive = function(alive) {
        this.element.SetHasClass("HealthBarDead", !alive);
    }

    this.Delete = function() {
        this.element.DeleteAsync(0);
    }
}

function HealthBar(elementId) {
    this.element = $(elementId);
    this.bars = [];
    this.currentHealth = 0;
    this.maxHealth = 0;
    this.entityId = 0;

    this.SetEntity = function(entityId) {
        this.entityId = entityId;

        this.Update();
    }

    this.Update = function(){
        var maxHealth = Math.round(Entities.GetMaxHealth(this.entityId));
        var health = Math.round(Entities.GetHealth(this.entityId));

        if (maxHealth != this.maxHealth) {
            this.maxHealth = maxHealth;

            for (var i = this.bars.length; i < maxHealth; i++) {
                var bar = new Bar(this.element);

                this.bars.push(bar);
                bar.SetAlive(health > i);
            }

            if (this.bars.length > maxHealth) {
                var removed = this.bars.splice(maxHealth, this.bars.length - maxHealth);

                for (var element of removed) {
                    element.Delete();
                }
            }
        }

        if (health != this.currentHealth) {
            this.currentHealth = health;

            for (var i = 0; i < this.bars.length; i++) {
                this.bars[i].SetAlive(this.currentHealth > i);
            }
        }
    }
}