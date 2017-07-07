from django.db import models
from django.utils.translation import ugettext_lazy as _


# Create your models here.
class Person(models.Model):
    name = models.CharField(_('Name'), max_length=255, unique=True)
    mail = models.EmailField(max_length=255, blank=True)

    def __unicode__(self):
        return self.name

    class Meta:
        ordering = ['name']
