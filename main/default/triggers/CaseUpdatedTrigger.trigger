trigger CaseUpdatedTrigger on Case (after update) {
    JCFS.API.pushUpdatesToJira();
}