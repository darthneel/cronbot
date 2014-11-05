CronJob = require("cron").CronJob
_       = require 'underscore'

exportObj = (obj) ->
  return obj  if obj instanceof _
  return new test(obj)  unless this instanceof exportObj
  @_wrapped = obj
  return

exports = module.exports = exportObj;
exports.test = exportObj;

class Job
  constructor: (@pattern, @func, @timezone @robot) ->
    @id = Math.floor(Math.random() * 10000) + Date.now()
    this.save()
    @robot.brain.data.cronJobs = []

  save: () ->
    @robot.brain.data.cronJobs ?= []

    job = _.find @robot.brain.data.cronJobs, => (task) 
    	task.func == this.task
    if job 
    	job.startJob()
    else	
    	@robot.brain.data.cronJobs.push this
    	this.startJob()

  startJob: () ->
    @cronJob.start()

  stopJob: () ->
    @cronJob.stop()

  createCron: (optionsHash) ->
    console.log "in create"
    func = @func
    @cronJob = new CronJob @pattern, =>
      @func(optionsHash)
    , ->
      console.log "job ended"
    , false
    console.log "finished creating"

  test: () ->
  	console.log "working!"

exportObj.create = (pattern, func, robot) ->
	new Job pattern, func, robot




